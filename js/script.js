let searchBtn = document.querySelector('.search-btn'),
menuToggle = document.querySelector('.menu-toggle'),
searchBox = document.querySelector('.search-box'),
navitems = document.querySelectorAll('.nav-item'),
nav = document.querySelector('nav ul'),
floatingSearch = document.querySelector('.mini-search')


searchBtn.addEventListener('click', ()=>{
    
    if(searchBox.classList.contains('expand')||floatingSearch.classList.contains('mini-search-show')){
        document.querySelector('.search-btn .fa-times').style.display = 'none'
        document.querySelector('.search-btn .fa-search').style.display = 'block'
    }else{
        document.querySelector('.search-btn .fa-times').style.display = 'block'
        document.querySelector('.search-btn .fa-search').style.display = 'none'
    }

    if(window.innerWidth <= 800){
        floatingSearch.classList.toggle('mini-search-show')
        nav.classList.remove('show')
        document.querySelector('.menu-toggle .fa-times').style.display = 'none'
        document.querySelector('.menu-toggle .fa-bars').style.display = 'block'
    }else{
        searchBox.classList.toggle('expand')
        navitems.forEach((item)=>{
            item.classList.toggle('hide')
        })
    }

})

menuToggle.addEventListener('click', ()=>{

    if(nav.classList.contains('show')){
        document.querySelector('.menu-toggle .fa-times').style.display = 'none'
        document.querySelector('.menu-toggle .fa-bars').style.display = 'block'
    }else{
        document.querySelector('.menu-toggle .fa-times').style.display = 'block'
        document.querySelector('.menu-toggle .fa-bars').style.display = 'none'
    }

    nav.classList.toggle('show')
    floatingSearch.classList.remove('mini-search-show')
    searchBox.classList.remove('expand')
    document.querySelector('.search-btn .fa-times').style.display = 'none'
        document.querySelector('.search-btn .fa-search').style.display = 'block'
})