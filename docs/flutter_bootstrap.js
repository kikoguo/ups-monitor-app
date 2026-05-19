// Flutter Web Bootstrap with HTML renderer fallback
if (!window._flutter) {
  window._flutter = {};
}

// Set build config with both canvaskit and html renderers
window._flutter.buildConfig = {
  "engineRevision": "42d3d75a56efe1a2e9902f52dc8006099c45d937",
  "builds": [
    {
      "compileTarget": "dart2js",
      "renderer": "canvaskit",
      "mainJsPath": "main.dart.js"
    },
    {
      "compileTarget": "dart2js",
      "renderer": "html",
      "mainJsPath": "main.dart.js"
    }
  ]
};

// Load the main flutter bootstrap
import('./flutter.js')
  .then((module) => {
    const loader = module.flutter.loader;
    loader.load({
      serviceWorkerSettings: {
        serviceWorkerVersion: ""4114672856" /* Flutter's service worker is deprecated and will be removed in a future Flutter release. */"
      }
    });
  })
  .catch((error) => {
    console.error('Failed to load Flutter:', error);
    document.body.innerHTML = '<div style="text-align:center;padding:50px;font-family:sans-serif;"><h2>加载失败</h2><p>请刷新页面重试</p></div>';
  });
