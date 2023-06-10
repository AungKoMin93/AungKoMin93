let university_filter = document.querySelector('#filter-btn'),
country_filter = document.querySelector('#country'),
major_filter = document.querySelector('#major')

function generateCard(){
    let cards = ''

    university_arr.forEach(university => {
        let cardHTML = `<div class="col-lg-4 col-sm-6 mb-3 h-100">
        <div class="card h-100">
            <div class="card-img-top overflow-hidden uni-img">
                <img src="${university.image}" alt="university_image" style="width: 100%;">
            </div>
            <div class="card-body">
                <h5>${university.name}</h5>
                <p>${university.country}</p>
                <p><small>Major - ${university.major}</small></p>
                <a href="university-detail.html" class="btn btn-success detail-btn" data-university-name="${university.name}">Learn More</a>
            </div>
        </div>
    </div>`;
        cards += cardHTML;        
    });

    return cards;
};

        university_filter.addEventListener('click', ()=>{        
            let result = ''
            if(country_filter.value == 'All'){
                result = generateCard()
            }else{
                let filtered = university_arr.filter(university => university.country === country_filter.value)

                filtered.forEach(filtered_uni => {
                    let cardHTML = `<div class="col-lg-4 col-sm-6 mb-3 h-100">
                    <div class="card h-100">
                        <div class="card-img-top overflow-hidden uni-img">
                            <img src="${filtered_uni.image}" alt="university_image" style="width: 100%;">
                        </div>
                        <div class="card-body">
                            <h5>${filtered_uni.name}</h5>
                            <p>${filtered_uni.country}</p>
                            <p><small>Major - ${filtered_uni.major}</small></p>
                            <a href="university-detail.html" class="btn btn-success detail-btn" data-university-name="${filtered_uni.name}">Learn More</a>
                        </div>
                    </div>
                </div>`;
                result+=cardHTML;
            
                });
            }
            

            document.querySelector('#universities').innerHTML = ''
            document.querySelector('#universities').innerHTML = result;
        })
        

document.querySelector('#universities').innerHTML = generateCard();

let detailBtns = document.querySelectorAll('.detail-btn')

detailBtns.forEach(detailBtn => {
    detailBtn.addEventListener('click', (e)=>{
        let targeted_university = e.target.getAttribute('data-university-name');
        localStorage.setItem('university-name', targeted_university)
    })
})