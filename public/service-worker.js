const cacheName = 'v1';
const appFiles = [
    'style.css',
    'questions.js',
    'background.webp',
    'site.webmanifest',
    'apple-touch-icon.png',
    'favicon-32x32.png',
    'favicon-16x16.png',
    'index.html',
    'questions.min.js',
];

self.addEventListener('install', async (event) => {
    console.log(`Service worker installed`);
    console.log(event);
    const cache = await caches.open(cacheName);
    const addAllPromise = cache.addAll(appFiles);
    event.waitUntil(addAllPromise);
});

self.addEventListener('fetch', async (event) => {
    console.log(`Fetch requested for ${event.request.url}`);

    let response = await caches.match(event.request);
    if (response) {
        console.log(`Returning cached response.`);
        return response;
    }

    console.log(`Fetching...`);
    response = await fetch(event.request);
    const cache = await caches.open(cacheName);
    await cache.put(event.request, response.clone());
    return response;
});
