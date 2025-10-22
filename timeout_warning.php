<script>
  const timeoutSeconds = 1800;
  const warningSeconds = 300;
  const warningDelay = (timeoutSeconds - warningSeconds) * 1000;

  setTimeout(() => {
    const warning = document.createElement('div');
    warning.textContent = "⚠️ You’ll be logged out in 5 minutes — refresh or access any page to stay logged in.";
    warning.style.position = 'fixed';
    warning.style.bottom = '20px';
    warning.style.left = '50%';
    warning.style.transform = 'translateX(-50%)';
    warning.style.backgroundColor = '#fff3cd';
    warning.style.color = '#856404';
    warning.style.padding = '12px 20px';
    warning.style.border = '1px solid #ffc107';
    warning.style.borderRadius = '6px';
    warning.style.fontFamily = 'Inter, sans-serif';
    warning.style.fontSize = '15px';
    warning.style.zIndex = '9999';
    document.body.appendChild(warning);
  }, warningDelay);
</script>