# {{ pascalCase name }} Web App

## Dev Requirements

1. [Node.js](https://nodejs.org/en/download/)
2. Yarn: `npm install -g yarn`

> These requirements are for development mode only.  
> You can run this project statically using Docker without having to install other dependencies.

## Run in dev mode

Dev mode allows hot reloading of files &amp; components, and JIT build; as opposed to AOT build +
static serving.

1. Install/update project dependencies: `yarn install`
2. Add `.env.local` file to the repository root folder, and fill it with the correct env variables:

   ```shell
   NEXT_PUBLIC_API_BASE=
   NEXT_PUBLIC_MAPBOX_API_KEY=
   NEXT_PUBLIC_FACEBOOK_APP_ID=
   # to use test social app login instead of prod one in backend
   # (optional, automatically true in dev mode)
   # NEXT_PUBLIC_API_TEST=true
   ```

3. Run in development mode with hot reload: `yarn dev`
4. Open [http://localhost:3000](http://localhost:3000) with your browser

## Run using Docker

Add the `.env.local` file mentioned in "Run in dev mode" to build the Docker with the correct
environment. Then, you can build the container and run as an image:

### Shell - Manual

```shell
# build
docker build -t nextjs-docker .
# run
# this docker exposes port 3000, you may forward to any other port
# (in this case 3100, to avoid conflict with dev mode run)
docker run -p 3100:3000 nextjs-docker
```

### NPM Script - Automated

```shell
# build & run via npm scripts if you have Node.js installed
yarn build:docker
yarn start:docker
```
