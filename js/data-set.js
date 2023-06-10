let university_arr = [
    {
        name: 'Harvard University',
        country: 'United States',
        major: 'Computer Science',
        image: `https://www.collegeboxes.com/wp-content/uploads/2022/04/harvard-university.jpg`,
        description: `Harvard University, established in 1636, is the oldest university in the US and highly esteemed worldwide. Named after its first benefactor, John Harvard, the institution boasts connections to numerous Nobel laureates, heads of state, and Pulitzer prizewinners among its extensive alumni network. Situated in Cambridge, Massachusetts, Harvard's expansive 5,000-acre campus houses 12 degree-granting schools, including the Radcliffe Institute for Advanced Study, and is renowned for its vast academic library and strong financial endowment.`
    },
    {
        name: 'Stanford University',
        country: 'United States',
        major: 'Architecture',
        image: `https://assets.simpleviewinc.com/simpleview/image/fetch/c_limit,q_75,w_1200/https://assets.simpleviewinc.com/simpleview/image/upload/crm/sanmateoca/shutterstock_4189008910-9b68011a5056a36_9b6802fa-5056-a36a-0bbb53c8e971b411.jpg`,
        description: `Stanford University, established in 1885 as a co-educational and non-denominational private institution, is renowned for its large campus and global prestige. Located in California's Silicon Valley, the university fosters an entrepreneurial spirit that contributed to the development of the region. Stanford boasts a significant number of Nobel laureates among its community and counts influential alumni from various fields, including business, politics, and technology. The university's extensive campus houses numerous departments, schools, and research facilities, and its fundraising efforts have resulted in significant investments in academic programs and infrastructure.`
    },
    {
        name: 'University of Oxford',
        country: 'United Kingdom',
        major: 'Law',
        image: `https://i.pinimg.com/564x/0c/89/50/0c895054ba280c1415007d88c2d3a7a5.jpg`,
        description: `The University of Oxford, the second oldest surviving university worldwide, holds the distinction of being the oldest in the English-speaking world. With a rich history dating back to teaching in 1096, the university consists of 44 colleges and halls, along with a vast library system. Oxford's diverse student body of approximately 22,000 includes a significant international representation from 140 countries. The institution boasts an impressive alumni network, featuring Olympic medallists, Nobel Prize winners, renowned world leaders, and notable figures from various fields such as science, literature, and entertainment.`
    },
    {
        name: 'Kyoto University',
        country: 'Japan',
        major: 'Engineering',
        image: `https://i.pinimg.com/564x/66/40/5c/66405cbb861f74ee388784dd7dec737c.jpg`,
        description: `Kyoto University, located in Kyoto, Japan, is a prestigious and leading research university. Established in 1897, it is one of Japan's oldest and most esteemed institutions of higher education. With a focus on academic excellence and innovation, Kyoto University is known for its contributions to various fields, including science, technology, medicine, and the humanities, making it a globally recognized center for advanced research and education.`
    },
    {
        name: 'University of Cambridge',
        country: 'United Kingdom',
        major: 'Computer Science',
        image: `https://i.pinimg.com/564x/d1/c7/12/d1c71208d1826908f14900529cebc405.jpg`,
        description: `The University of Cambridge, founded in 1209, is one of the world's oldest and most renowned universities. Located in Cambridge, England, it is a prestigious academic institution known for its excellence in teaching and research across a wide range of disciplines. With a rich history and a vibrant community of scholars, Cambridge University continues to be a global leader in advancing knowledge and shaping the future through its exceptional education and groundbreaking discoveries.`
    },
    {
        name: 'Princeton University',
        country: 'United States',
        major: 'Cyber Security',
        image: `https://i.pinimg.com/564x/75/da/bc/75dabce080fdf34e39c2cd0184aa37fb.jpg`,
        description: `Princeton University, founded in 1746, is a highly regarded Ivy League institution located in Princeton, New Jersey, USA. Renowned for its academic excellence, the university offers a wide range of programs in the humanities, social sciences, natural sciences, and engineering. With a beautiful campus and a strong emphasis on research and critical thinking, Princeton University continues to be a prestigious institution that fosters intellectual growth and prepares students for impactful contributions in their chosen fields.`
    }
]

let mentors = [
    {
        name: 'John Dick',
        country: 'USA',
        major: 'Biology',
        description: `With a strong background in business administration and finance, I am an experienced scholarship mentor at Princeton University. Holding an MBA degree from a top-ranked business school, they have a deep understanding of the intricacies of the corporate world. I have an impressive portfolio, having worked at multinational corporations and leading financial institutions. I expertise in financial management and strategic planning makes them an invaluable resource for aspiring scholars. Additionally, I actively participates in community service initiatives, dedicating my time and skills to volunteering for organizations focused on financial literacy and empowerment.`,
        image: 'https://fprimecapital.com/wp-content/uploads/2016/11/allan-2-400x400.jpg'
    },
    {
        name: 'Tommy Hoverland',
        country: 'Sweden',
        major: 'Health Science',
        description: `I bring a wealth of knowledge in computer science and technology to my role as a scholarship mentor at Stanford University. With a strong academic background in computer engineering and a track record of outstanding academic achievements, they are well-equipped to guide students pursuing STEM fields. I have an impressive portfolio, having worked on cutting-edge projects at renowned tech companies and contributed to open-source software development. I actively engage in volunteering activities, mentoring underprivileged youth in coding and computer literacy, and promoting diversity in the tech industry.`,
        image: 'https://fprimecapital.com/wp-content/uploads/2015/01/alex-2-400x400.jpg'
    },
    {
        name: 'Tim Snowy',
        country: 'UK',
        major: 'Environmental Health Science',
        description: `With a background in environmental science and sustainability, I am a dedicated scholarship mentor at University of Cambridge. I hold a Ph.D. in Environmental Studies and have conducted impactful research on climate change and sustainable development. My portfolio includes contributions to environmental policy initiatives and collaborations with environmental organizations. As a social lead in their respective community, I organize workshops, awareness campaigns, and clean-up drives to inspire sustainable practices and engage others in environmental stewardship. Additionally, I actively volunteers for environmental conservation projects, aiming to make a positive impact on the planet and inspire future generations to prioritize sustainability.`,
        image: 'https://fprimecapital.com/wp-content/uploads/2016/11/debbie-2-400x400.jpg'
    },
    {
        name: 'Arthur Morgan',
        country: 'USA',
        major: 'Social Science',
        description: `As a scholarship mentor at Harvard University, I have a background in social sciences and a passion for community development. I hold a master's degree in sociology and have conducted extensive research on social issues, making them well-versed in critical analysis and social theory. I have a diverse portfolio of community-based projects, advocating for social justice, and working with local organizations to address societal challenges. My leadership skills shine through their involvement in various student organizations and their role as a social lead, organizing events and initiatives that foster inclusivity and civic engagement.`,
        image: 'https://fprimecapital.com/wp-content/uploads/2018/02/eleni-2-400x400.jpg'
    },
    {
        name: 'Itadori Otsu',
        country: 'Japan',
        major: 'Mathematics',
        description: `With a strong background in mathematics and a passion for education, I serve as a scholarship mentor at Kyoto University. They hold a Ph.D. in Mathematics from a renowned institution, with exceptional academic results and a deep understanding of mathematical concepts. My portfolio includes published research in the field of abstract algebra and participation in mathematical competitions. In addition to their scholarly pursuits, I actively engage in volunteering activities, teaching mathematics to underprivileged students and organizing math clubs to promote interest in the subject. I also take on a leadership role in their community, organizing math fairs and workshops to foster a love for mathematics among students.`,
        image: 'https://fprimecapital.com/wp-content/uploads/2019/05/20190530-f-prime-capital-1276-400x400.jpg'
    },
    {
        name: 'Sasha',
        country: 'USA',
        major: 'Computer Science',
        description: `With a background in computer engineering and a knack for problem-solving, I serve as a scholarship mentor at Princeton University. Holding a master's degree in Computer Engineering, they have excelled academically with a focus on advanced computer architecture and system design. My portfolio showcases their expertise in hardware design and programming languages. I actively participate in volunteering activities, teaching coding and robotics to disadvantaged students and organizing tech camps to empower the next generation. I take on a leadership role in their community by spearheading computer science clubs and organizing technology-focused events to promote digital literacy and innovation.`,
        image: 'https://fprimecapital.com/wp-content/uploads/2022/05/20220503-f-prime-capital-0225-1-400x400.jpg'
    }
]