// Shows the real APK size next to the download button when the site is
// served over http(s) (a plain file:// open can't do a HEAD request).
(async () => {
  const meta = document.getElementById('apk-size');
  const link = document.getElementById('download-link');
  if (!meta || !link) return;

  try {
    const response = await fetch(link.href, { method: 'HEAD' });
    const bytes = Number(response.headers.get('content-length'));
    if (bytes) {
      const mb = (bytes / (1024 * 1024)).toFixed(1);
      meta.textContent = `para Android · ${mb} MB`;
    }
  } catch {
    // Ignore — static "para Android" label stays as-is.
  }
})();
