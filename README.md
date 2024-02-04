# UNOFFICIAL PufferPanel Docker images

> [!WARNING]  
> This currently only offers images for pufferpanel v2 as v3 is still unstable.

## Building

You can build the images yourself. There's also an example compose file.  
Otherwise, the images will build once a month.

## Tags

> [!NOTE]  
> If you need any other combination or support for source game servers, build a custom image based on the base image

For all architectures the following tags are available:
- `<arch>` for just the panel
- `<arch>-java` for Java 8, 16, 17 & 21
- `<arch>-java8` for Java 8
- `<arch>-java16` for Java 16
- `<arch>-java17` for Java 17
- `<arch>-nodejs` for whatever nodejs version is in the alpine `nodejs` package

## Supported architectures
- arm64

## Tested on
- Ampere A1 arm64-v8 (Oracle Cloud)
