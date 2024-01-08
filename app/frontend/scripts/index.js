let displayListOfObjects = [];

let currentPaginationPage = 0;
let currentPaginationNum = 5;
let currentTableName = null;

function recreateTable() {
  resetTable(displayListOfObjects);
  createTable(displayListOfObjects);
  createPaginationRow(displayListOfObjects);
}

function changeDataSource(name) {
  displayListOfObjects = name;
  currentPaginationPage = 0;
  recreateTable();
}

function sortByKey(key) {
  displayListOfObjects = displayListOfObjects.sort((l, r) => (l[key] > r[key] ? 1 : -1));
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
  // window.location.href = current_loc.replace(from, to)
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

  (u = up.get("u")), (p = up.get("p"));

  if (u == undefined || p == undefined) {
    red("index.html", "login.html");
  }
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
  console.log(table_el);

  tr_header = document.createElement("tr");
  tr_header.classList.add("header_tr");

  for (var key in dict_list[0]) {
    th = document.createElement("th");
    th.innerHTML = key;
    tr_header.appendChild(th);
  }

  crth_header = document.createElement("th");
  crth_header.classList.add("crth");
  crth_header.innerHTML = '<input id="cb" class="crud_c" type="button" name="create" value="+">';

  tr_header.appendChild(crth_header);
  table_el.appendChild(tr_header);

  const slice_from = Number(currentPaginationPage) * Number(currentPaginationNum);
  const slice_to = slice_from + Number(currentPaginationNum);

  dict_list.slice(slice_from, slice_to).forEach((o) => {
    let row_id = null;

    o.doc_id ? (row_id = o.doc_id) : null;
    o.author_id ? (row_id = o.author_id) : null;
    o.department_id ? (row_id = o.department_id) : null;

    tr_el = document.createElement("tr");
    tr_el.classList.add("row_tr");

    for (var key in o) {
      const customClass = (key === "doc_id") | (key === "author_id") | (key === "department_id") ? "th_cell_id" : null;

      th_el = document.createElement("th");
      th_el.classList.add("th_cell_id");
      th_el.innerHTML = `<textarea disabled class="th_cell ${customClass}" value="${o[key]}">${o[key]}</textarea>`;
      tr_el.appendChild(th_el);
    }

    ui_th = document.createElement("th");
    ui_th.classList.add("crth");
    ui_th.innerHTML = `<input id="cb" data-action="tr_update" class="crud_u" type="button" name="update" value="+"><input id="cb" data-action="tr_delete" class="crud_d" type="button" name="delete" value="-">`;

    const updateButton = ui_th.querySelector('[data-action="tr_update"]');
    const deleteButton = ui_th.querySelector('[data-action="tr_delete"]');

    updateButton.addEventListener("click", (event) => onUpdateClick(row_id, tr_el, event));
    deleteButton.addEventListener("click", (event) => deleteTableRow(row_id, event));
    tr_el.appendChild(ui_th);
    table_el.appendChild(tr_el);
  });
}

function onUpdateClick() {}

function deleteTableRow(id, event) {
  const row_node = event.target.parentElement.parentElement;
  if (row_node.className === "row_tr") {
    const url = `http://localhost:8000/api/${currentTableName}/${id}`;

    fetch(url, { method: "DELETE" })
      .then((resp) => {
        console.log(resp);
        row_node.remove();
      })
      .catch((error) => console.log(error));
  }
}

function getDocuments() {
  const url = "http://localhost:8000/api/documents/joined";
  currentTableName = "documents";

  fetch(url, { method: "GET" }).then((resp) => {
    resp.json().then((d) => {
      console.log(d);
      displayListOfObjects = d;
      recreateTable();
    });
  });
}

function getAuthors() {
  const url = "http://localhost:8000/api/authors";
  currentTableName = "authors";

  fetch(url, { method: "GET" }).then((resp) => {
    resp.json().then((d) => {
      console.log(d);
      displayListOfObjects = d;
      recreateTable();
    });
  });
}

function getDepartments() {
  const url = "http://localhost:8000/api/departments";
  currentTableName = "departments";

  fetch(url, { method: "GET" }).then((resp) => {
    resp.json().then((d) => {
      console.log(d);
      displayListOfObjects = d;
      recreateTable();
    });
  });
}

function onStartup() {
  redirectToLoginPage();
  createTable(displayListOfObjects);
  createPaginationRow(displayListOfObjects);
  getDocuments();
}

onStartup();
