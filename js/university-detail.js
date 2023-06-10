let university_name = localStorage.getItem('university-name')

let image_box = document.querySelector('#img-box img')

let result = university_arr.find(university => university.name === university_name)

image_box.src = result.image;

document.querySelector('#university-name').innerHTML = result.name;
document.querySelector('#uni-description').innerHTML = result.description;