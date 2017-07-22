# Devtools with openjdk6 kepler eclipse nodejs 6.11

```
docker run -v ~/workspace/:/root/workspace/ -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -d -v /home/relato/projetos:/data -v ~/.m2:/root/.m2 --name devtools6 relato/devtools-java6-kepler-ee
```

