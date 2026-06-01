[← Back to projects](../README.md)

# Project 2: Log Analyzer

## Goal

Read a log file and generate statistics:

```text
Total requests: 12000
Status 200: 10300
Status 500: 87
Top 10 paths
Slowest endpoints
```

## Focus Areas

- `File.stream!/1`
- `Stream` vs `Enum`
- `reduce`
- String and binary parsing
- Large-file processing

## Challenge

Support a large log file without loading the entire file into memory.
