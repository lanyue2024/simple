
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const simpleHost = request.headers.get('simplehost');
    const sourceIP = request.headers.get('X-Real-IP');

    if (!simpleHost) {
        switch (url.pathname) {
            case '/':
                return new Response(sourceIP, { status: 200 });

            default:
                return new Response("Not Found.", { status: 404 });
        }
    }

    let newUrl = url;
    newUrl.hostname = simpleHost;
    let newReq = new Request(newUrl, request);
    newReq.headers.set("X-Forwarded-For", "");
    newReq.headers.set("X-Real-IP", "");
    return await fetch(newReq);
  },
};

