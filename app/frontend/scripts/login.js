function loginUser() {
	username_el = document.getElementsByClassName("uin")[0].value;
	password_el = document.getElementsByClassName("pin")[0].value;

	let url = `http://localhost:8000/api/auth/login/user?username=${username_el}&password=${password_el}`
	fetch(url, {method: "POST"})
	.then((resp) => {
		log_p = document.getElementById("log");
		resp.json().then((d) => {
			if (resp.status < 300) {
				log_p.style["color"] = "green";
				log_p.innerHTML = d.message;

				var p = new URLSearchParams();
				p.append("u", username_el)
				p.append("p", password_el)
				document.cookie = "crd="+p.toString()
				let current_loc = window.location.href;
				window.location.href = current_loc.replace("login.html", "index.html")
			} else {
				log_p.style["color"] = "red";
				log_p.innerHTML = d.message;
			}
		});
	})
	.catch((resp) => {
		console.log("catch");
		log_p = document.getElementById("log");
		log_p.innerHTML = resp;
	})
}
