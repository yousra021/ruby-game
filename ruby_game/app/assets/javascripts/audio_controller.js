document.addEventListener("DOMContentLoaded", () => {
    const audio = document.getElementById("game-audio");
    const toggleAudioBtn = document.getElementById("toggle-audio");
  
    if (!audio) return;
    if (window.__audio_initialized__) return;
    window.__audio_initialized__ = true;
  
    // Restaurer la position et l'état
    const savedTime = sessionStorage.getItem("audioTime");
    const wasMuted = sessionStorage.getItem("audioMuted");
  
    if (savedTime) {
      audio.currentTime = parseFloat(savedTime);
    }
  
    if (wasMuted === "true") {
      audio.muted = true;
      if (toggleAudioBtn) toggleAudioBtn.textContent = "Activer le son";
    } else {
      audio.muted = false;
      if (toggleAudioBtn) toggleAudioBtn.textContent = "Couper le son";
    }
  
    // Lecture déclenchée à la première interaction (clic ou souris)
    const tryPlayAudio = () => {
      if (audio.paused) {
        audio.play().catch((e) => {
          console.warn("Autoplay bloqué :", e);
        });
      }
  
      document.removeEventListener("click", tryPlayAudio);
      document.removeEventListener("mousemove", tryPlayAudio);
    };
  
    document.addEventListener("click", tryPlayAudio, { once: true });
    document.addEventListener("mousemove", tryPlayAudio, { once: true });
  
    // Sauvegarde boucle
    setInterval(() => {
      sessionStorage.setItem("audioTime", audio.currentTime);
      sessionStorage.setItem("audioMuted", audio.muted);
    }, 1000);
  
    // Bouton mute/demute
    if (toggleAudioBtn) {
      toggleAudioBtn.addEventListener("click", () => {
        audio.muted = !audio.muted;
        toggleAudioBtn.textContent = audio.muted ? "Activer le son" : "Couper le son";
      });
    }
  });
  