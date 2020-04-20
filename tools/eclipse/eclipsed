# Eclipse

## 1.Initializing Java Tooling

> An internal error occurred during: "Initializing Java Tooling". org/eclipse/jdt/internal/core/search/matching/MatchLocator

Fixed this by removing this file in each workspace:

```
[workspace]/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
```

Opening STS from the command line (on mac: `./STS.app/Contents/MacOS/STS -clean`) and viewing stack traces on startup led me to this answer: