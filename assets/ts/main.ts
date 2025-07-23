document.addEventListener("DOMContentLoaded", function() {
  const links = document.querySelectorAll('a');
  links.forEach(link => {
    // Leave external links to open in a new tab, but force internal links to open in the same tab
    if (link.hostname === window.location.hostname) {
      link.setAttribute('target', '_self');
    }
  });
});
