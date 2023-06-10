let mentor_name = localStorage.getItem('mentor-name')

let result = mentors.find(mentor => mentor.name === mentor_name)

document.querySelector('#name').innerHTML = result.name
document.querySelector('#major').innerHTML = result.major
document.querySelector('#about').innerHTML = result.description
document.querySelector('.profile img').src = result.image