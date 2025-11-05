#!/usr/bin/env tsx
/**
 * Claude Code Status Line
 */

import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';

const DEBUG = true;

const Colours = {
  AMBER: '\x1b[38;2;255;180;195m',     // Bright pink-coral/salmon
  ORANGE: '\x1b[38;2;255;160;200m',    // Bright pink
  CLAUDE_ORANGE: '\x1b[38;2;255;120;80m', // Warm orange (Claude Code branding)
  PURPLE: '\x1b[38;2;210;195;230m',    // Bright lavender
  BLUE: '\x1b[38;2;140;195;240m',      // Bright light blue
  CYAN: '\x1b[38;2;120;200;200m',      // Bright teal
  GREEN: '\x1b[38;2;100;180;180m',     // Bright teal (for success states)
  RED: '\x1b[38;2;255;160;200m',       // Bright pink (for error/behind states)
  YELLOW: '\x1b[38;2;255;220;120m',    // Warm pleasing yellow
  GRAY: '\x1b[38;2;140;155;175m',      // Lighter gray-blue
  DARK_GRAY: '\x1b[38;2;120;145;165m', // Lighter blue-gray for separators
  WHITE: '\x1b[38;2;250;250;250m',     // Bright white
  BOLD: '\x1b[1m',
  DIM: '\x1b[2m',
  RESET: '\x1b[0m',
} as const;

const Icons = {
  THINKING: '✳︎',
  GIT_CLEAN: '✓',
  GIT_DIRTY: '±',
  GIT_AHEAD: '↑',
  GIT_BEHIND: '↓',
  COST: '$',
} as const;

interface GitInfo {
  branch: string;
  clean: boolean;
  ahead: number;
  behind: number;
  changedFiles: number;
}

interface InputData {
  transcript_path?: string;
  workspace?: {
    current_dir?: string;
  };
  cwd?: string;
  cost?: {
    total_cost_usd?: number;
  };
  model?: {
    display_name?: string;
  };
  version?: string;
}

interface ClaudeSettings {
  alwaysThinkingEnabled?: boolean;
}

interface ClaudeConfig {
  mcpServers?: Record<string, unknown>;
  oauthAccount?: {
    accountUuid?: string;
  };
}

interface Usage {
  input_tokens?: number;
  cache_creation_input_tokens?: number;
  cache_read_input_tokens?: number;
}

function getGradientColor(percentage: number): string {
  // Clamp percentage between 0 and 100
  const p = Math.max(0, Math.min(100, percentage));

  let r: number, g: number, b: number;

  if (p < 50) {
    // Interpolate from green to yellow (0% to 50%)
    const ratio = p / 50;
    r = Math.round(160 + (255 - 160) * ratio);  // 160 -> 255
    g = Math.round(240);                         // 240 -> 240
    b = Math.round(160 * (1 - ratio));          // 160 -> 0
  } else {
    // Interpolate from yellow to red (50% to 100%)
    const ratio = (p - 50) / 50;
    r = Math.round(255);                         // 255 -> 255
    g = Math.round(220 - (220 - 100) * ratio);  // 220 -> 100
    b = Math.round(100 * (1 - ratio));          // 100 -> 0
  }

  return `\x1b[38;2;${r};${g};${b}m`;
}

function getGitStatusColor(changedFiles: number): string {
  // Scale: max at 50 changed files (increments of 5)
  const maxFiles = 50;
  const percentage = Math.min(100, (changedFiles / maxFiles) * 100);

  // Start: mild coral/salmon (255, 180, 195)
  // End: bright red (255, 100, 100)
  const startR = 255, startG = 180, startB = 195;
  const endR = 255, endG = 100, endB = 100;

  const ratio = percentage / 100;
  const r = Math.round(startR + (endR - startR) * ratio);
  const g = Math.round(startG + (endG - startG) * ratio);
  const b = Math.round(startB + (endB - startB) * ratio);

  return `\x1b[38;2;${r};${g};${b}m`;
}

function simpleHash(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash; // Convert to 32bit integer
  }
  return Math.abs(hash);
}

function getRepoColor(repoName: string): string {
  // Hash the repo name to get a consistent value
  const hash = simpleHash(repoName);
  // Normalize to 0-1 range
  const normalized = (hash % 1000) / 1000;

  // Define a pleasing gradient through multiple colors from the palette
  // Teal -> Blue -> Lavender -> Pink -> Coral
  const gradientStops = [
    { r: 120, g: 200, b: 200 },  // Teal
    { r: 140, g: 195, b: 240 },  // Light blue
    { r: 210, g: 195, b: 230 },  // Lavender
    { r: 255, g: 160, b: 200 },  // Pink
    { r: 255, g: 200, b: 170 },  // Coral
  ];

  // Find which segment we're in
  const segmentCount = gradientStops.length - 1;
  const position = normalized * segmentCount;
  const segmentIndex = Math.floor(position);
  const segmentRatio = position - segmentIndex;

  // Handle edge case where we're at the very end
  const startColor = gradientStops[Math.min(segmentIndex, segmentCount - 1)];
  const endColor = gradientStops[Math.min(segmentIndex + 1, segmentCount)];

  // Interpolate between the two colors
  const r = Math.round(startColor.r + (endColor.r - startColor.r) * segmentRatio);
  const g = Math.round(startColor.g + (endColor.g - startColor.g) * segmentRatio);
  const b = Math.round(startColor.b + (endColor.b - startColor.b) * segmentRatio);

  return `\x1b[38;2;${r};${g};${b}m`;
}

function getGitInfo(cwd: string): GitInfo | null {
  try {
    // Check if git repo exists
    execSync('git rev-parse --git-dir', {
      cwd,
      timeout: 1000,
      stdio: 'pipe',
    });

    // Get branch name
    const branch = execSync('git rev-parse --abbrev-ref HEAD', {
      cwd,
      timeout: 1000,
      encoding: 'utf-8',
    }).trim();

    // Get status
    const statusOutput = execSync('git status --porcelain --branch', {
      cwd,
      timeout: 1000,
      encoding: 'utf-8',
    });

    const lines = statusOutput.split('\n');
    const changedFiles = lines.filter(line => line && !line.startsWith('##')).length;
    const isClean = changedFiles === 0;

    let ahead = 0;
    let behind = 0;
    const branchLine = lines.find(line => line.startsWith('##'));
    if (branchLine) {
      if (branchLine.includes('ahead')) {
        const match = branchLine.match(/ahead (\d+)/);
        if (match) ahead = parseInt(match[1], 10);
      }
      if (branchLine.includes('behind')) {
        const match = branchLine.match(/behind (\d+)/);
        if (match) behind = parseInt(match[1], 10);
      }
    }

    return {
      branch,
      clean: isClean,
      ahead,
      behind,
      changedFiles,
    };
  } catch {
    return null;
  }
}

function formatGitStatus(gitInfo: GitInfo): string {
  const parts: string[] = [];

  if (gitInfo.clean) {
    parts.push(`${Colours.CYAN}${gitInfo.branch}${Colours.RESET}`);
    parts.push(`${Colours.GREEN}${Icons.GIT_CLEAN}${Colours.RESET}`);
  } else {
    const statusColour = getGitStatusColor(gitInfo.changedFiles);
    parts.push(`${statusColour}${gitInfo.branch}${Colours.RESET}`);
    parts.push(`${statusColour}${Icons.GIT_DIRTY}${gitInfo.changedFiles}${Colours.RESET}`);
  }

  if (gitInfo.ahead) {
    parts.push(`${Colours.GREEN}${Icons.GIT_AHEAD}${gitInfo.ahead}${Colours.RESET}`);
  }
  if (gitInfo.behind) {
    parts.push(`${Colours.RED}${Icons.GIT_BEHIND}${gitInfo.behind}${Colours.RESET}`);
  }

  return parts.join(' ');
}

function getContextInfo(data: InputData): string | null {
  try {
    const transcriptPath = data.transcript_path;
    if (!transcriptPath || !fs.existsSync(transcriptPath)) {
      return null;
    }

    // JSONL format: each line is a separate JSON object
    let latestUsage: Usage | null = null;

    const content = fs.readFileSync(transcriptPath, 'utf-8');
    const lines = content.split('\n');

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) continue;

      try {
        const entry = JSON.parse(trimmed);

        // Skip non-message entries (summaries, metadata)
        if (!['assistant', 'user'].includes(entry.type)) {
          continue;
        }

        // Usage is nested: entry -> message -> usage
        const message = entry.message || {};
        const usage: Usage = message.usage || {};

        if (usage && usage.input_tokens) {
          latestUsage = usage;
        }
      } catch {
        continue;
      }
    }

    if (!latestUsage) {
      return null;
    }

    // Total includes cache tokens
    const totalTokens =
      (latestUsage.input_tokens || 0) +
      (latestUsage.cache_creation_input_tokens || 0) +
      (latestUsage.cache_read_input_tokens || 0);

    // Claude Code context is ~200k tokens with auto-compact at ~160k
    const maxContext = 200_000;
    const percentage = (totalTokens / maxContext) * 100;

    const colour = getGradientColor(percentage);

    return `${Colours.DIM}${colour}${percentage.toFixed(0)}%${Colours.RESET}`;
  } catch {
    return null;
  }
}

function getThinkingMode(data: InputData): string | null {
  try {
    const settingsPath = path.join(process.env.HOME || '~', '.claude', 'settings.json');
    if (!fs.existsSync(settingsPath)) {
      return null;
    }

    const content = fs.readFileSync(settingsPath, 'utf-8');
    const settings: ClaudeSettings = JSON.parse(content);

    const alwaysThinking = settings.alwaysThinkingEnabled || false;
    if (alwaysThinking) {
      return Icons.THINKING;
    }

    return null;
  } catch {
    return null;
  }
}

function getMcpServers(data: InputData): string[] {
  const mcpServers: string[] = [];

  // 1. Check ~/.claude.json for user-level MCP servers
  try {
    const claudeConfig = path.join(process.env.HOME || '~', '.claude.json');
    if (fs.existsSync(claudeConfig)) {
      const content = fs.readFileSync(claudeConfig, 'utf-8');
      const config: ClaudeConfig = JSON.parse(content);
      const servers = config.mcpServers || {};
      mcpServers.push(...Object.keys(servers));
    }
  } catch {
    // Ignore errors
  }

  // 2. Check project-level MCP configurations
  const cwd = data.workspace?.current_dir || data.cwd || '';
  if (cwd) {
    // Check .mcp.json in project root
    const projectMcp = path.join(cwd, '.mcp.json');
    if (fs.existsSync(projectMcp)) {
      try {
        const content = fs.readFileSync(projectMcp, 'utf-8');
        const mcpConfig: ClaudeConfig = JSON.parse(content);
        const servers = mcpConfig.mcpServers || {};
        mcpServers.push(...Object.keys(servers));
      } catch {
        // Ignore errors
      }
    }

    // Check .claude/.mcp.json
    const claudeMcp = path.join(cwd, '.claude', '.mcp.json');
    if (fs.existsSync(claudeMcp)) {
      try {
        const content = fs.readFileSync(claudeMcp, 'utf-8');
        const mcpConfig: ClaudeConfig = JSON.parse(content);
        const servers = mcpConfig.mcpServers || {};
        mcpServers.push(...Object.keys(servers));
      } catch {
        // Ignore errors
      }
    }
  }

  // Remove duplicates while preserving order
  const seen = new Set<string>();
  const unique: string[] = [];
  for (const server of mcpServers) {
    if (!seen.has(server)) {
      seen.add(server);
      unique.push(server);
    }
  }

  return unique;
}

function formatMcpServers(serverNames: string[]): string | null {
  if (serverNames.length === 0) {
    return null;
  }

  const display = serverNames.join(' ').trim();
  return `${Colours.PURPLE}${Colours.DIM}${display}${Colours.RESET}`;
}

function isUsingApiKey(): boolean {
  const claudeConfig = path.join(process.env.HOME || '~', '.claude.json');
  if (!fs.existsSync(claudeConfig)) {
    return true;
  }

  try {
    const content = fs.readFileSync(claudeConfig, 'utf-8');
    const config: ClaudeConfig = JSON.parse(content);

    // If oauthAccount exists with valid data, using subscription
    const oauthAccount = config.oauthAccount || {};
    if (oauthAccount && oauthAccount.accountUuid) {
      return false;
    }

    return true;
  } catch {
    return true;
  }
}

function getCostInfo(data: InputData): string | null {
  if (!isUsingApiKey()) {
    return null;
  }

  const costData = data.cost || {};
  if (costData && costData.total_cost_usd) {
    const cost = costData.total_cost_usd;
    let colour: string;
    if (cost < 1.0) {
      colour = Colours.GREEN;
    } else if (cost < 5.0) {
      colour = Colours.YELLOW;
    } else {
      colour = Colours.RED;
    }
    return `${colour}${Icons.COST} $${cost.toFixed(3)}${Colours.RESET}`;
  }
  return null;
}

function main(): void {
  try {
    // Read JSON from stdin
    const input = fs.readFileSync(0, 'utf-8');
    const inputData: InputData = JSON.parse(input);

    if (DEBUG) {
      try {
        const logPath = '/tmp/claude-statusline.jsonl';
        fs.appendFileSync(logPath, JSON.stringify(inputData, null, 2) + '\n');
      } catch (e) {
        console.error(`Warning: Could not write log file: ${e}`);
      }
    }

    const parts: string[] = [];

    const cwd = inputData.workspace?.current_dir || '';
    if (cwd) {
      const dirName = path.basename(cwd) || '/';
      const repoColor = getRepoColor(dirName);
      parts.push(`${repoColor}${dirName}${Colours.RESET}`);
    }

    if (cwd) {
      const gitInfo = getGitInfo(cwd);
      if (gitInfo) {
        const gitStatus = formatGitStatus(gitInfo);
        parts.push(gitStatus);
      }
    }

    const serverNames = getMcpServers(inputData);
    if (serverNames.length > 0) {
      const mcp = formatMcpServers(serverNames);
      if (mcp) {
        parts.push(mcp);
      }
    }

    const cost = getCostInfo(inputData);
    if (cost) {
      parts.push(cost);
    }

    const model = inputData.model || {};
    let modelName = model.display_name || 'Unknown';
    modelName = modelName.replace(/[^a-zA-Z]/g, '').toLowerCase();
    const thinking = getThinkingMode(inputData);
    if (thinking) {
      modelName += ' ' + thinking;
    }

    parts.push(`${Colours.CLAUDE_ORANGE}${modelName}${Colours.RESET}`);

    const context = getContextInfo(inputData);
    if (context) {
      parts.push(context);
    }

    const version = inputData.version;
    if (version) {
      parts.push(`${Colours.GRAY}v${version}${Colours.RESET}`);
    }

    console.log(parts.join(`${Colours.DARK_GRAY} ・ ${Colours.RESET}`));
  } catch (error) {
    console.error('Error: Invalid JSON input');
    process.exit(2);
  }
}

main();
