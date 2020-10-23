function closeUI(container, data) {
  if (container === "char-select")
    $("#char-select-container").css({ display: "none" });

  if (container === "char-create")
    $("#char-creation-container").css({ display: "none" });
}

function openUI(container, data) {
  if (container === "char-select")
    $("#char-select-container").css({ display: "block" });

  if (container === "char-create")
    $("#char-creation-container").css({ display: "block" });
}

// When a new character is created, open the character creation screen.
$(".create-new-character").click(function () {
  closeUI("char-select");
  openUI("char-create");
});

// When the NUI message gets called.
$(function () {
  window.addEventListener("message", function (event) {
    if (event.data.type === "enableui") {
      openUI("char-select", event.data);
    }
  });
});
