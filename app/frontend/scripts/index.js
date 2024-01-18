let displayListOfObjects = [];

let currentPaginationPage = 0;
let currentPaginationNum = 5;
let currentTableName = null;

const boxContainer = document.getElementById("create-row-block");

let isUserAdmin = -1;

function recreateTable() {
  resetTable(displayListOfObjects);
  createTable(displayListOfObjects);
  createPaginationRow(displayListOfObjects);
}

function sortByKey(key) {
  displayListOfObjects = displayListOfObjects.sort((l, r) => (l[key] > r[key] ? 1 : -1));
}

function setSorting(key) {
	option_row = Array.from(document.getElementsByClassName("option_row"))[0]
	menuGenerators = {
		"author": createAuthorOptionMenu,
		"department": createDepartmentsOptionMenu,
		"docs.name": createDocumentsOptionMenu
	}

	optionMenu = menuGenerators[key]()
	optionMenu.style.width = "250px"
	optionMenu.id = "om_sort"

	if (option_row.firstChild.className = "islct") {
		option_row.removeChild(option_row.firstChild)
	}
	option_row.insertBefore(optionMenu, option_row.firstChild)
}

function sortTable() {
	const key_el = document.getElementById("om_sort")
	const by_el = Array.from(document.getElementsByClassName("sort_o"))[0]
	const url = `http://localhost:8000/api/documents?sort_by=${by_el.value}&sort_key_value=${key_el.value}`;
    fetch(url, { method: "GET" })
	  .then((resp) => {
		  if (resp.ok) {
			resp.json().then((d) => {
			  displayListOfObjects = d;
			  recreateTable();
			});
		  } else {
			  if (resp.detail == null) {
				alert(`Error:\n${JSON.stringify(resp.message)}`);
			  } else {
				alert(`Error:\n${JSON.stringify(resp.detail[0].msg)}`);
			  }
		  }
	  })
	  .catch((err) => {
		alert(err)
	  });
}

function setPaginationNum(num) {
  currentPaginationNum = num;
  currentPaginationPage = 0;
  recreateTable();
}

function setPaginationPage(pag_page) {
  currentPaginationPage = pag_page;
  recreateTable();
}

function red(from, to) {
  let current_loc = window.location.href;
  window.location.href = current_loc.replace(from, to);
}

function redirectToLoginPage() {
  try {
    var crd = document.cookie
      .split("; ")
      .find((row) => row.startsWith("crd"))
      .substring(4);
  } catch {
    red("index.html", "login.html");
  }

  var up = new URLSearchParams(crd);

  (u = up.get("u")), (p = up.get("p")), (a = up.get("a"));
  isUserAdmin = a;

  if (u == undefined || p == undefined) {
    red("index.html", "login.html");
  }
  
  user_type_el = Array.from(document.getElementsByClassName("user_type"))[0];
  user_type_el.innerHTML = isUserAdmin == 1 ? `${u}(Admin)` : `${u}(User)`;
  user_type_el.style.color = "white";
}

function createAuthorOptionMenu() {
	const url = "http://localhost:8000/api/authors";
	selecter = document.createElement("select")
	selecter.name = "author";
	selecter.classList.add("islct");
    (async () => {
        const query = await fetch(url);
        const res = await query.json();
		Array.from(res).forEach((e) => {
			op = document.createElement("option");
			op.value = e.author_id;
			op.innerHTML = e.fullname;
			selecter.appendChild(op);
		})
    })();
	return selecter;
}

function createDepartmentsOptionMenu() {
	const url = "http://localhost:8000/api/departments";
	selecter = document.createElement("select")
	selecter.name = "department";
	selecter.classList.add("islct");
    (async () => {
        const query = await fetch(url);
        const res = await query.json();
		Array.from(res).forEach((e) => {
			op = document.createElement("option");
			op.value = e.department_id;
			op.innerHTML = e.name;
			selecter.appendChild(op);
		})
    })();
	return selecter;
}

function createDocumentsOptionMenu() {
	const url = "http://localhost:8000/api/documents/joined";
	selecter = document.createElement("select")
	selecter.name = "docs";
	selecter.classList.add("islct");
    (async () => {
        const query = await fetch(url);
        const res = await query.json();
		Array.from(res).forEach((e) => {
			op = document.createElement("option");
			op.value = e.name;
			op.innerHTML = e.name;
			selecter.appendChild(op);
		})
    })();
	return selecter;
}

function resetTable(list_of_objects) {
  table_el = document.getElementById("data__table");
  table_el.replaceChildren([]);
  tr_row = document.createElement("tr");
  tr_row.classList.add("header_tr");
  table_el.appendChild(tr_row);
}


function createPaginationRow(list_of_objects) {
  num_of_pages = Math.ceil(list_of_objects.length / currentPaginationNum);

  pag_row = document.getElementsByClassName("pagination_block")[0];
  last_button = document.getElementsByClassName("pag_ctrl_b")[1];

  pag_num_buttons = Array.from(document.getElementsByClassName("pag_num_b"));
  pag_num_buttons.forEach((b) => {
    b.remove();
  });

  Array(num_of_pages)
    .fill(0)
    .map((_, i) => i + 1)
    .forEach((num) => {
      but = document.createElement("button");
      but.onclick = function () {
        setPaginationPage(num - 1);
      };
      but.classList.add("pag_num_b");
      but.innerHTML = num;
      pag_row.appendChild(but);
    });
}

function createTable(dict_list) {
  table_el = document.getElementById("data__table");
  let dictKeys = [];

  tr_header = document.createElement("tr");
  tr_header.classList.add("header_tr");

  for (var key in dict_list[0]) {
    dictKeys.push(key);
    th = document.createElement("th");
    th.innerHTML = key;
    tr_header.appendChild(th);
  }

  const allowed = ["doc_id", "name", "folder", "version", "author"]
  if (dictKeys.includes("doc_id")) {
	  dictKeys = dictKeys.filter((el) => {
		  if (allowed.includes(el)) {
			  return el
		  }
	  })
  }


  if (isUserAdmin == 1) {
	  crth_header = document.createElement("th");
	  crth_header.classList.add("crth");
	  crth_header.innerHTML = '<input id="cb" data-action="tr_add" class="crud_c" type="button" name="create" value="+">';
	  crth_header.addEventListener("click", () => addBox(dictKeys, currentTableName));
	  tr_header.appendChild(crth_header);
  }

  table_el.appendChild(tr_header);

  const slice_from = Number(currentPaginationPage) * Number(currentPaginationNum);
  const slice_to = slice_from + Number(currentPaginationNum);

  dict_list.slice(slice_from, slice_to).forEach((o) => {
	// !!!
    let row_id = 0;

    o.doc_id ? (row_id = o.doc_id) : null;
    o.author_id ? (row_id = o.author_id) : null;
    o.department_id ? (row_id = o.department_id) : null;

    tr_el = document.createElement("tr");
    tr_el.classList.add("row_tr");

    for (var key in o) {
      const customClass = (key === "doc_id") | (key === "author_id") | (key === "department_id") ? "th_cell_id" : null;

      th_el = document.createElement("th");
      th_el.classList.add("th_cell_id");
      th_el.innerHTML = `<textarea data-id=${customClass} data-key=${key} disabled class="th_cell ${customClass}" value="${o[key]}">${o[key]}</textarea>`;
      tr_el.appendChild(th_el);
    }

    ui_th = document.createElement("th");
    ui_th.classList.add("crth");
	if (isUserAdmin == 1) {
		ui_th.innerHTML = `<input id="cb" data-action="tr_update" class="crud_u" type="button" name="update" value="+"><input id="cb" data-action="tr_delete" class="crud_d" type="button" name="delete" value="-">`;

		const updateButton = ui_th.querySelector('[data-action="tr_update"]');
		const deleteButton = ui_th.querySelector('[data-action="tr_delete"]');

		console.log(row_id)
		updateButton.addEventListener("click", (event) => onUpdateClick(row_id, updateButton, event));
		deleteButton.addEventListener("click", (event) => deleteTableRow(row_id, event));

		tr_el.appendChild(ui_th);
	}

    table_el.appendChild(tr_el);
  });
}

function createAboutModal() {
	modal = Array.from(document.getElementsByClassName("modal_info"))[0]
	if (modal.style.display === "block") {
		modal.style.display = "none";
	} else {
		modal.style.display = "block";
		modal.innerHTML = `
			<img src="./assets/me.jpeg" width="140">
			<h1>Автор:</h1>
			<h2>Нейенбург Тимофей Андреевич, студент группы 21-ВТ-2.</h2>
			<hr style="margin: 10px 0;">
			<h1>Тема:</h1>
			<h2> «Управление конфигурацией».</h2>
			<h2> Система для накопления, просмотра и модификации информации о формируемом документообороте в процессе проектирования программного продукту</h2>
		`
	}
}

function addBox(dictKeys, currentTableName) {
  if (boxContainer.style.display === "block") {
    boxContainer.style.display = "none";
    boxContainer.innerHTML = "";
  } else {
    boxContainer.style.display = "block";

    dictKeys.forEach((el) => {
	  if (el == "department") {
		  selecter = createDepartmentsOptionMenu();
		  boxContainer.append(selecter);
	  } else if (el == "author") {
		  selecter = createAuthorOptionMenu();
		  boxContainer.append(selecter);
	  } else {
		  if (!(el.includes("id"))) {
		    inputContainer = document.createElement("div");
		    inputContainer.innerHTML = `<input class="islct_in" type="text" placeholder=${el} name='${el}'>`;
		    boxContainer.append(inputContainer);
		  }
	  }
    });

    buttonContainer = document.createElement("div");
    buttonContainer.innerHTML = `<input type="button" value="add"/>`;
    buttonContainer.classList.add("crb");
    buttonContainer.addEventListener("click", () => submitAddRow(currentTableName));
    boxContainer.append(buttonContainer);
  }
}

function submitAddRow(currentTableName) {
  const selectInputs = boxContainer.querySelectorAll("select");
  const allAddInputs = boxContainer.querySelectorAll("input[type='text']");

  const idPredefined = {
	"authors": "author_id",
	"documents": "doc_id",
	"departments": "department_id",
  }

  const elements = Array.from(selectInputs).concat(Array.from(allAddInputs))

  const data = [];
  let obj = {};
  let key = idPredefined[currentTableName]
  obj[key] = 0

  elements.forEach((el) => {
	obj[el.getAttribute("name")] = el.value;
  });
  data.push(obj);

  const url = `http://localhost:8000/api/${currentTableName}`;

  (async () => {
    const query = await fetch(url, {
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      method: "POST",
      body: JSON.stringify(data[0]),
    });

    const res = await query.json();

    if (res.message == "ok") {
      alert("Data saved");
    } else {
	  if (res.detail == null) {
		  alert(`Error:\n${JSON.stringify(res.message)}`);
	  } else {
		  alert(`Error:\n${JSON.stringify(res.detail[0].msg)}`);
	  }
    }
  })();
}

function onUpdateClick(row_id, updateButton, event) {
  const row_node = event.target.parentElement.parentElement;
  const allInputs = row_node.querySelectorAll("[data-id]");

  if (updateButton.value === "+") {
    allInputs.forEach((el) => {
      if (el.getAttribute("data-id") === "null") {
        el.removeAttribute("disabled");
        el.style.border = "1px solid black";
        el.style.borderRadius = "5px";
      }
    });

    updateButton.value = "ok";
  } else {
    const dataArray = [];

    let obj = {};
    allInputs.forEach((el) => {
      obj[el.getAttribute("data-key")] = el.value;
    });
    dataArray.push(obj);

    const url = `http://localhost:8000/api/${currentTableName}/${row_id}`;

    (async () => {
      const query = await fetch(url, {
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        method: "PUT",
        body: JSON.stringify(dataArray[0]),
      });

      const res = await query.json();

      if (res.message == "ok") {
        alert("Data saved");

        allInputs.forEach((el) => {
          el.setAttribute("disabled", true);
          el.style.border = "0";
        });

        updateButton.value = "+";
      } else {
        alert("Error");
      }
    })();
  }
}

function deleteTableRow(row_id, event) {
  const row_node = event.target.parentElement.parentElement;
  if (row_node.className === "row_tr") {
    const url = `http://localhost:8000/api/${currentTableName}/${row_id}`;

	var to_del = confirm("Are you sured?")
	
	if (to_del == true) {
      fetch(url, { method: "DELETE" })
        .then((resp) => {
	  	if (resp.ok) {
	  	  row_node.remove();
	  	} else {
	  	    if (resp.detail == null) {
	  	      alert(`Error:\n${JSON.stringify(resp.message)}`);
	  	    } else {
	  	      alert(`Error:\n${JSON.stringify(resp.detail[0].msg)}`);
	  	    }
	  	}
        })
        .catch((error) => alert(error));
	  }
  }
}

function getDocuments() {
  const url = "http://localhost:8000/api/documents/joined";
  currentTableName = "documents";

  fetch(url, { method: "GET" }).then(
	(resp) => {
	  if (resp.ok) {
        resp.json().then((d) => {
          displayListOfObjects = d;
          recreateTable();
	      hideSortingOptions("block")
        });
	  } else {
		  if (resp.detail == null) {
		    alert(`Error:\n${JSON.stringify(resp.message)}`);
		  } else {
		    alert(`Error:\n${JSON.stringify(resp.detail[0].msg)}`);
		  }
	  }
  })
  .catch((err) => {alert(err)})
}

function getAuthors() {
  const url = "http://localhost:8000/api/authors";
  currentTableName = "authors";

  fetch(url, { method: "GET" }).then(
	(resp) => {
	  if (resp.ok) {
        resp.json().then((d) => {
          displayListOfObjects = d;
          recreateTable();
	      hideSortingOptions("none")
        });
	  } else {
		  if (resp.detail == null) {
		    alert(`Error:\n${JSON.stringify(resp.message)}`);
		  } else {
		    alert(`Error:\n${JSON.stringify(resp.detail[0].msg)}`);
		  }
	  }
	})
	.catch((err) => {alert(err)})
}

function getDepartments() {
  const url = "http://localhost:8000/api/departments";
  currentTableName = "departments";

  fetch(url, { method: "GET" }).then(
	(resp) => {
	  if (resp.ok) {
		resp.json().then((d) => {
		  displayListOfObjects = d;
		  recreateTable();
		  hideSortingOptions("none")
		});
	  } else {
		  if (resp.detail == null) {
			alert(`Error:\n${JSON.stringify(resp.message)}`);
		  } else {
			alert(`Error:\n${JSON.stringify(resp.detail[0].msg)}`);
		  }
	  }
  })
  .catch((err) => {alert(err)})
}

function hideSortingOptions(hide) {
	so = Array.from(document.getElementsByClassName("option_row"))[0]
	so.style.display = hide;
}

function logout() {
	document.cookie = "crd=; expires=Thu, 01 Jan 1970 00:00:00 UTC;"
    red("index.html", "login.html");
}

function onStartup() {
  redirectToLoginPage();
  createTable(displayListOfObjects);
  createPaginationRow(displayListOfObjects);
  getDocuments();
}

onStartup();
