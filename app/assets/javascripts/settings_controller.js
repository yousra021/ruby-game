document.addEventListener("turbo:load", () => {
  console.log("⚙️ JS settings chargé");

  const settingsBtn = document.getElementById("open-settings");
  const closeSettingsBtn = document.getElementById("close-settings");
  const settingsModal = document.getElementById("settings-modal");
  const toggleAudioBtn = document.getElementById("toggle-audio");
  const audio = document.getElementById("game-audio");

  if (!settingsBtn || !closeSettingsBtn || !settingsModal || !toggleAudioBtn || !audio) {
    console.warn("❌ Élément(s) introuvable(s)");
    return;
  }

  // Gestion ouverture/fermeture de la modale
  settingsBtn.addEventListener("click", () => {
    settingsModal.classList.remove("hidden");
  });

  closeSettingsBtn.addEventListener("click", () => {
    settingsModal.classList.add("hidden");
  });

  // État audio (restaurer)
  const wasMuted = sessionStorage.getItem("audioMuted");
  if (wasMuted === "true") {
    audio.muted = true;
    toggleAudioBtn.textContent = "Activer le son";
  } else {
    audio.muted = false;
    toggleAudioBtn.textContent = "Couper le son";
  }

  // Clic bouton mute/demute
  toggleAudioBtn.addEventListener("click", () => {
    audio.muted = !audio.muted;
    sessionStorage.setItem("audioMuted", audio.muted);
    toggleAudioBtn.textContent = audio.muted ? "Activer le son" : "Couper le son";
    console.log("🎛️ audio.muted:", audio.muted);
  });
});
