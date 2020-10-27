let chosenID = null;
let previousID = null;

function closeUI(container, data) {
  if (container === "char-select")
    $("#char-select-container").css({ display: "none" });

  if (container === "char-create")
    $("#char-creation-container").css({ display: "none" });
}

function openUI(container, data) {
  if (container === "char-select") {
    // Load in any characters available into the character selection window.
    if (data !== null) {
      if (data.characters !== null) {
        $.each(data.characters, function (index, char) {
          let charid = char.identifier.charAt(4);
          $("[data-charid=" + charid + "]").html(
            "<h5 class='card-title character-name'>" +
              char.first_name +
              " " +
              char.middle_name +
              " " +
              char.last_name +
              "</h5><p class='card-text'>Cash: " +
              char.money +
              "</p><p class='card-text'>Bank: " +
              char.bank +
              "</p></p><p class='card-text'>DOB: " +
              char.date_of_birth +
              "</p>"
          );
          $("[data-charid=" + charid + "]").attr("data-ischar", "1"); // Ensures that the system knows theres a character in this slot.
        });
      }
    }
    $("#char-select-container").css({ display: "block" });
  }

  if (container === "char-create")
    $("#char-creation-container").css({ display: "block" });
}

// Gather the character ID from the slot that it chooses from.
// Called by an onClick function in index.html.
function gatherCharID(charSlot) {
  // Check to see if a character has not been created in that slot first.

  chosenID = charSlot.getAttribute("data-charid");

  // Alter the CSS of the chosen ID class to add a border.
  $("[data-charid=" + chosenID + "]").css({ border: "3px solid red" });

  if (previousID !== null && previousID !== chosenID) {
    $("[data-charid=" + previousID + "]").css({ border: "none" });
  }
  previousID = chosenID;
}

$("#select-character").click(function (event) {
  event.preventDefault();
  // Have it so that you need to click on a character slot before playing or creating a character.
  if (chosenID !== null) {
    $.post(
      "https://sal_characters/play",
      JSON.stringify({
        charID: chosenID,
      })
    );
    closeUI("char-select");
  } else {
    console.log("Tell the user that they need to choose an ID"); // TODO complete.
  }
});

// When a new character is created, open the character creation screen.
$("#create-new-character").click(function () {
  // Have it so that you need to click on a character slot before playing or creating a character.
  // TODO run a check to make sure a character won't get overriden.
  if (chosenID !== null) {
    closeUI("char-select");
    openUI("char-create");
  } else {
    console.log("Tell the user that they need to choose an ID"); // TODO complete.
  }
});

function verifyFormInformation(firstName, middleName, lastName, dob) {
  if (firstName === "" || lastName === "") return "name empty";

  // Check if the registered character is older than 18.
  let currentTime = new Date();
  let currentYear = currentTime.getFullYear();

  // DOB format: yyyy/mm/dd
  let dobYear = parseInt(dob.substr(6, 9));

  // Date of birth will return invalid if it shows the character is not older than 18 or if there was no dob submitted.
  if (dobYear > currentYear - 18 || isNaN(dobYear)) return "invalid dob";

  return "ok";
}

$("#go-back").click(function (event) {
  closeUI("char-create");
  openUI("char-select", null);
});

$("#create-character").submit(function (event) {
  // Gather then values from each input field.
  // Create an object based around them.
  // Submit to client.
  event.preventDefault();

  let firstName = $("#first-name").val();
  let middleName = $("#middle-name").val();
  let lastName = $("#last-name").val();
  let dob = $("#dob").val();

  let isResponseValid = verifyFormInformation(
    firstName,
    middleName,
    lastName,
    dob
  );

  if (isNaN(middleName)) middleName = ""; // TODO still needs checking

  switch (isResponseValid) {
    case "ok":
      $.post(
        "https://sal_characters/register",
        JSON.stringify({
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          dateOfBirth: dob,
          charID: chosenID,
        })
      );
      closeUI("char-create");
      break;
    case "name empty":
      console.log("Tell client to have a non-empty first/last name!"); // TODO implement error checking statements.
      break;
    case "invalid dob":
      console.log("Tell client to change their dob"); // TODO finish
      break;
    default:
      console.log("Error occurred"); // TODO finish
  }
});

// When the NUI message gets called.
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
