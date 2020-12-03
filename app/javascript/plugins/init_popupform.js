const initPopupform = () => {
  const updateButtons = document.querySelectorAll('#updateDetails');
  const favDialog = document.getElementById('favDialog');
  const cancelButton = document.getElementById('cancelMessage');

  // Le bouton "mettre à jour les détails" ouvre la boîte de dialogue
  updateButtons.forEach((updateButton) => {
    updateButton.addEventListener('click', function onOpen() {
      if (typeof favDialog.showModal === "function") {
        favDialog.showModal();
      } else {
        console.error("L'API dialog n'est pas prise en charge par votre navigateur");
      }
    });
    cancelButton.addEventListener('click', (event) => {
      event.preventDefault();
      favDialog.close();
    });
  });
};

export { initPopupform };
