let documents = [
	{
		"id": "0",
		"name": "ESPD.19.103.2",
		"version": "0.0.1-beta",
		"folder": "ftp://storage/root/files/espd/001.md", 
		"created_at": 17283818283,
		"author_id": "0"
	},
	{
		"id": "1",
		"name": "IEEE-ABC",
		"version": "0.0.0",
		"folder": "ftp://storage/root/files/ieee/abc.md", 
		"created_at": 19239192,
		"author_id": "1"
	},
	{
		"id": "2",
		"name": "OAE_CCC",
		"version": "1.1.1",
		"folder": "ftp://storage/root/files/general.md", 
		"created_at": 12939293,
		"author_id": "21"
	},
	{
		"id": "1",
		"name": "IEEE-ABC",
		"version": "0.0.0",
		"folder": "ftp://storage/root/files/ieee/abc.md", 
		"created_at": 19239192,
		"author_id": "1"
	},
	{
		"id": "2",
		"name": "OAE_CCC",
		"version": "1.1.1",
		"folder": "ftp://storage/root/files/general.md", 
		"created_at": 12939293,
		"author_id": "21"
	},
	{
		"id": "1",
		"name": "IEEE-ABC",
		"version": "0.0.0",
		"folder": "ftp://storage/root/files/ieee/abc.md", 
		"created_at": 19239192,
		"author_id": "1"
	},
	{
		"id": "2",
		"name": "OAE_CCC",
		"version": "1.1.1",
		"folder": "ftp://storage/root/files/general.md", 
		"created_at": 12939293,
		"author_id": "21"
	},
	{
		"id": "1",
		"name": "IEEE-ABC",
		"version": "0.0.0",
		"folder": "ftp://storage/root/files/ieee/abc.md", 
		"created_at": 19239192,
		"author_id": "1"
	},
	{
		"id": "2",
		"name": "OAE_CCC",
		"version": "1.1.1",
		"folder": "ftp://storage/root/files/general.md", 
		"created_at": 12939293,
		"author_id": "21"
	},
	{
		"id": "1",
		"name": "IEEE-ABC",
		"version": "0.0.0",
		"folder": "ftp://storage/root/files/ieee/abc.md", 
		"created_at": 19239192,
		"author_id": "1"
	},
	{
		"id": "2",
		"name": "OAE_CCC",
		"version": "1.1.1",
		"folder": "ftp://storage/root/files/general.md", 
		"created_at": 12939293,
		"author_id": "21"
	},
]

let authors = [
	{
		"id": "0",
		"fullname": "Michael D. Brown",
		"education": "full high",
		"university": "BFU",
		"department_id": "0"
	}
]

let departments = [
	{
		"id": "0",
		"name": "development",
		"head": "Jorsh Bash",
		"phone": "+7-909-5151-90-42",
	}
]

let displayListOfObjects = documents;

let paginationPage = 0;
let paginationNum = 5;


function changeDataSource(name) {
	displayListOfObjects = name;
	paginationPage = 0;
	resetTable(displayListOfObjects);
	createTable(displayListOfObjects);
	createPaginationRow(displayListOfObjects);
}

function sortByKey(key) {
	displayListOfObjects = displayListOfObjects.sort((l, r) => l[key] > r[key] ? 1 : -1);
}

function fetchDocuments() {
	axios.get("http://localhost:8080/api/documents")
		.then(resp => console.log(resp.data))
		.catch(err => console.log(err))
}

function setPaginationNum(num) {
	paginationNum = num;
	paginationPage = 0;
	resetTable(displayListOfObjects);
	createTable(displayListOfObjects);
	createPaginationRow(displayListOfObjects);
}

function setPaginationPage(pag_page) {
	paginationPage = pag_page;
	resetTable(displayListOfObjects);
	createTable(displayListOfObjects);
	createPaginationRow(displayListOfObjects);
}

function redirectToLoginPage() {
	var crd = document.cookie
		.split("; ")
		.find(row => row.startsWith("crd"))
		.substring(4);

	var up = new URLSearchParams(crd);
	u = up.get("u"),
	p = up.get("p")

	console.log(u, p)
	if (u == undefined || p == undefined) {
		let current_loc = window.location.href;
		window.location.href = current_loc.replace("index.html", "login.html")
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
	num_of_pages = Math.ceil(list_of_objects.length/paginationNum);
	
	pag_row = document.getElementsByClassName("pagination_block")[0];
	last_button = document.getElementsByClassName("pag_ctrl_b")[1];

	pag_num_buttons = Array.from(document.getElementsByClassName("pag_num_b"));
	pag_num_buttons.forEach(b => {
		b.remove();
	})

	Array(num_of_pages).fill(0).map((_, i) => i+1).forEach((num) => {
		but = document.createElement("button");
		but.onclick = function() {setPaginationPage(num-1)};
		but.classList.add("pag_num_b")
		but.innerHTML = num;
		pag_row.appendChild(but);
	})
}

function createTable(dict_list) {
	table_el = document.getElementById("data__table");
	console.log(table_el)

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

	const slice_from = Number(paginationPage)*Number(paginationNum);
	const slice_to = slice_from + Number(paginationNum);

	dict_list.slice(slice_from, slice_to).forEach((o) => {
		tr_el = document.createElement("tr");
		tr_el.classList.add("row_tr");
		for (var key in o) {
			th_el = document.createElement("th")
			th_el.innerHTML = o[key];
			tr_el.appendChild(th_el);
		}
		ui_th = document.createElement("th");
		ui_th.classList.add("crth");
		ui_th.innerHTML = '<input id="cb" class="crud_u" type="button" name="update" value="+"><input id="cb" class="crud_d" type="button" name="delete" value="-">'
		tr_el.appendChild(ui_th)
		table_el.appendChild(tr_el)
	})
}

redirectToLoginPage();
createTable(displayListOfObjects);
createPaginationRow(displayListOfObjects);
