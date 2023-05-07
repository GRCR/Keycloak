window.onload = (event) => {
  console.log("page is fully loaded");
  const isInit = document.getElementById("isInit");
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

      console.log("dialog 5 second ");
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
  // OTP form js starts here
  const submitOtp = document.getElementById("submitOtp");
  const generateOtp = document.getElementById("generateOtp");
  const getOtpBtn = document.getElementById("getOtp");
  const resendOtpBtn = document.getElementById("resendOtp");
  const tryAnotherWay = document.getElementById("tryAnotherWay");
  const resendId = document.getElementById("resendId");

  if (tryAnotherWay !== null) {
    tryAnotherWay.addEventListener("click", () => {
      generateOtp.classList.toggle("hidden");

      resendId.classList.toggle("hidden");
      tryAnotherWay.classList.toggle("hidden");
      submitOtp.classList.toggle("hidden");
    });
  }

  if (resendOtpBtn !== null) {
    resendOtpBtn.addEventListener("click", () => {
      resendId.classList.toggle("hidden");
      tryAnotherWay.classList.toggle("hidden");

      toggleResendOtp();
    });
  }
  // Have to handle getOtp click in java, also have to reload the otp submit form
  //   if (getOtpBtn !== null) {
  //       getOtpBtn.addEventListener("click", () => {
  //           submitOtp.classList.toggle("hidden");
  //           generateOtp.classList.toggle("hidden");

  //           toggleResendOtp();

  //       });
  //   }

  if (isInit !== null) {
    console.log("is Init: ", isInit.value);
    console.log("generate otp: ", generateOtp.classList);
    if (isInit.value === "Yes"){
        generateOtp.classList.add("hidden");
     toggleResendOtp();
    }
  }

  function toggleResendOtp() {
    setTimeout(function () {
      if (resendId !== null) {
        resendId.classList.toggle("hidden");
      }
      if (tryAnotherWay !== null) {
        tryAnotherWay.classList.toggle("hidden");
      }
      console.log("otp 5 second ");
    }, 5000);
  }
  // OTP form js ends here
};
