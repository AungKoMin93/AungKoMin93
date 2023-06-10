function generateCard(){
    let cards = ''

    mentors.forEach(mentor => {
        let cardHTML = `<div class="col-lg-4 col-sm-6 mb-3 h-100">
        <div class="card h-100">
            <div class="card-img-top overflow-hidden uni-img">
                <img src="${mentor.image}" alt="university_image" style="width: 100%;">
            </div>
            <div class="card-body">
                <h5>${mentor.name}</h5>
                <p>${mentor.country}</p>
                <p><small>${mentor.major}</small></p>
                <a href="./mentor-detail.html" class="btn btn-warning detail-btn" data-mentor="${mentor.name}">Learn More</a>
            </div>
        </div>
    </div>`;
        cards += cardHTML;
    });

    return cards;
};

document.querySelector('#mentors').innerHTML = generateCard()

let detailBtns = document.querySelectorAll('.detail-btn')

detailBtns.forEach(detailBtn => {
    detailBtn.addEventListener('click', (e)=>{
        let targeted_mentor = e.target.getAttribute('data-mentor')
        localStorage.setItem('mentor-name', targeted_mentor)
    })
})
