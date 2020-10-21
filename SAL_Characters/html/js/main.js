$(function () {
  window.addEventListener("message", function (event) {
    if (event.data.type == "enableui") {
      document.body.style.display = "block";
    }
  });
});
