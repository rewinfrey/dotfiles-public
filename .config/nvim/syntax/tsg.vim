" tree-sitter-graph syntax file
" Language: tree-sitter-graph
" Last Change: 2023-05-15
" Author: Rick Winfrey <rewinfrey@github.com>
" Maintainer: Rick Winfrey <rewinfrey@github.com>
" Repository: https://github.com/tree-sitter/tree-sitter-graph.git
" URL: https://github.com/tree-sitter/tree-sitter-graph

syn spell toplevel
syn match Function "(?<=\\(\\s*)(and|end-column|end-row|internal|is-empty|is-null|length|named-child-count|named-child-index|node|node-type|not|or|plus|replace|source-text|start-column|start-row)\\b"
syn match Constant "(#false|#nil|#true)"
syn match Tag '[\[\](){}]*'
syn match String '\".*\"'
syn match Todo "@\w*"
syn keyword Type attr attribute edge node symbol
syn keyword Constant for global if let print scan set some var
syn match Delimiter ";.*$"
