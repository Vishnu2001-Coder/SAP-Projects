const baseUrl = "/odata/v4/my";

// CITY
async function getCity() {
    const city = document.getElementById("city").value;

    const res = await fetch(`${baseUrl}/getGeoInfoCity(city='${city}')`);

    if (!res.ok) {
        console.error("Error:", res.status);
        return;
    }

    const data = await res.json();

    document.getElementById("cityResult").innerText =
        JSON.stringify(data, null, 2);
}

// PINCODE
async function getPincode() {
    const pincode = document.getElementById("pincode").value;

    const res = await fetch(`${baseUrl}/getGeoInfoPincode(pincode='${pincode}')`);

    if (!res.ok) {
        console.error("Error:", res.status);
        return;
    }

    const data = await res.json();

    document.getElementById("pincodeResult").innerText =
        JSON.stringify(data, null, 2);
}