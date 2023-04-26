window.onload = (event) => {
  console.log("page is fully loaded");
  const dropdownButton = document.querySelector(".dropdown");
  const dropdownList = document.querySelector(".dropdown-menu");
  const alertDialog = document.getElementById("alertDialog");
  const closeDialogBtn = document.getElementById("closeDialog");

  

  if (closeDialogBtn !== null) {
    closeDialogBtn.addEventListener("click", () => {
      closeDialog();
    });
    setTimeout(function () {
        closeDialog();
   
       console.log("5 second ");
     }, 5000);
  }
  if (dropdownButton !== null && dropdownList !== null) {
    dropdownButton.addEventListener("click", () => {
      console.log("clicked on dropdown");
      dropdownList.classList.toggle("hidden");
    });
  }
  function closeDialog() {
    alertDialog.classList.add("hidden");
  }
};
