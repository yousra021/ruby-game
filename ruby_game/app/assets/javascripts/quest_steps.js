document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("quest-steps-container");
  const addBtn = document.getElementById("add-step-btn");
  const previewContainer = document.getElementById("quest-steps-preview");

  const titleInput = document.getElementById("quest_title");
  const descriptionInput = document.getElementById("quest_description");
  const xpInput = document.getElementById("quest_reward_experience");

  const previewTitle = document.getElementById("preview-title");
  const previewDescription = document.getElementById("preview-description");
  const previewXP = document.getElementById("preview-xp");

  if (!addBtn || !container || !previewContainer) return;

  let index = container.children.length;

  function updateMetaPreview() {
    if (previewTitle) previewTitle.textContent = titleInput?.value || "...";
    if (previewDescription) previewDescription.textContent = descriptionInput?.value || "...";
    if (previewXP) previewXP.textContent = xpInput?.value || "...";
  }

  function updateStepPreview() {
    const steps = container.querySelectorAll(".quest-step");
    previewContainer.innerHTML = "";

    steps.forEach((step, i) => {
      const descriptionField = step.querySelector("input[name*='[description]']");
      const riddleField = step.querySelector("input[name*='[riddle_attributes][question]']");
      const npcField = step.querySelector("input[name*='[npc_attributes][name]']");
      
      const description = descriptionField?.value || "(pas de description)";
      const riddleText = riddleField?.value || "Aucune";
      const npcText = npcField?.value || "Aucun";
      
      previewContainer.insertAdjacentHTML("beforeend", `
        <div class="mb-4">
          <p class="font-semibold">Étape ${i + 1} :</p>
          <p>${description}</p>
          <p>🧠 Énigme : ${riddleText}</p>
          <p>⚔️ Combat : ${npcText}</p>
        </div>
      `);
    });
  }

  function refreshPreview() {
    updateMetaPreview();
    updateStepPreview();
  }

  addBtn.addEventListener("click", () => {  
    fetch(`/gamemaster/quests/new_step_template?index=${index}`)
      .then(response => response.text())
      .then(html => {
        container.insertAdjacentHTML("beforeend", html);
        index++;
        refreshPreview();
      })
      .catch(err => console.error("Erreur FETCH :", err));
  });

  container.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-step")) {
      e.preventDefault();
      e.target.closest(".quest-step").remove();
      refreshPreview();
    }
  });

  document.addEventListener("input", refreshPreview);
  document.addEventListener("change", refreshPreview);

  refreshPreview(); // on load
});
