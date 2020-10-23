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

// TODO Run verification checks on form.
// TODO Make sure form is secure.
$("#create-character").submit(function (event) {
  // Gather then values from each input field.
  // Create an object based around them.
  // Submit to client.
  event.preventDefault();

  let firstName = $("#first-name").val();
  let middleName = $("#middle-name").val();
  let lastNight = $("#last-name").val();
  let dob = $("#dob").val();

  // TODO Post to the client function.
});

// When the NUI message gets called.
// TODO be able to load in any character data if the player has any characters available.
$(function () {
  // Waiting for the server to open the UI.
  window.addEventListener("message", function (event) {
    if (event.data.type === "enableui") {
      openUI("char-select", event.data);
    }
  });

  // Date system for the DOB field.
  let date_input = $('input[name="dob"]'); //our date input has the name "date"
  let container =
    $(".bootstrap-iso form").length > 0
      ? $(".bootstrap-iso form").parent()
      : "body";
  let options = {
    format: "mm/dd/yyyy",
    container: container,
    todayHighlight: true,
    autoclose: true,
  };
  date_input.datepicker(options);
});
