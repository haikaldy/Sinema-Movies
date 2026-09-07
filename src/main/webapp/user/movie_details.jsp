<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // --- MOCK DATABASE LOGIC ---
    // Since we don't have a real DB, we check the 'title' parameter 
    // and manually set the details for the specific movie.
    
    String title = request.getParameter("title");
    String img = request.getParameter("img");
    
    // Default values (if no match found)
    String director = "Unknown Director";
    String cast = "Cast not available";
    String synopsis = "No synopsis available for this movie.";
    String runtime = "120 mins";
    
    // DATA FOR AVATAR
    if (title != null && title.contains("Avatar")) {
        director = "James Cameron";
        cast = "Sam Worthington, Zoe Saldaña, Sigourney Weaver, Stephen Lang, Oona Chaplin, Cliff Curtis, Britain Dalton, Trinity Jo-Li Bliss, Jack Champion";
        synopsis = "Avatar 3: Fire and Ash is the explosive third instalment in James Cameron’s ground-breaking cinematic saga. Set several years after The Way of Water, the story plunges audiences deeper into the richly imagined world of Pandora—this time venturing into volcanic regions. As human forces return with more destructive technology and a renewed hunger to exploit Pandora’s natural resources, the peace between Na’vi clans begins to crack. Jake Sully and Neytiri, still reeling from past losses, must guide their family through a new chapter of conflict and survival. Their children—now older and more involved—play central roles as the story introduces powerful new Na’vi tribes forged in fire and hardened by ancient wars. Fire and Ash reflects both the literal destruction threatening the planet and the emotional fallout tearing through the hearts of its protectors. Volcanic eruptions, scorched forests, and ash-filled skies create a visually arresting backdrop as the Na’vi unite against a common enemy. Among the key antagonists is a reborn Quaritch and a new military leader who will stop at nothing to burn Pandora to the ground. Expect thrilling action sequences, deeper emotional arcs, and the return of key characters alongside new allies and enemies. The film explores themes of generational trauma, environmental vengeance, and the fragile balance between revenge and redemption.";
        runtime = "3 hr 15 mins";
    } 
    // DATA FOR MINECRAFT
    else if (title != null && title.contains("Minecraft")) {
        director = "Jared Hess";
        cast = "Jason Momoa, Jack Black, Emma Myers, Danielle Brooks, Sebastian Hansen, Jennifer Coolidge";
        synopsis = "A mysterious portal pulls four misfits into the Overworld, a bizarre, cubic wonderland that thrives on imagination. To get back home, they'll have to master the terrain while embarking on a magical quest with an unexpected crafter named Steve.";
        runtime = "1 hr 41 mins";
    }
    
    // DATA FOR WEAPONS
    else if (title != null && title.contains("Weapons")) {
        director = "Zach Cregger";
        cast = "Josh Brolin, Julia Garner, Alden Ehrenreich, Austin Abrams, Cary Christopher, Toby Huss, Benedict Wong, Amy Madigan";
        synopsis = "When all but one child from the same classroom mysteriously vanish on the same night at exactly the same time, a community is left questioning who or what is behind their disappearance.";
        runtime = "2 hr 8 mins";
    }
    
    // DATA FOR THE LONG WALK
    else if (title != null && title.contains("The Long Walk")) {
        director = "Francis Lawrence";
        cast = "David Jonsson, Cooper Hoffman, Mark Hamill, Ben Wang, Roman Griffin Davis, Garrett Wareing, Judy Greer, Charlie Plummer ";
        synopsis = "Teens participate in a gruelling high-stakes contest where they must continuously walk or be shot by a member of their military escort.";
        runtime = "1 hr 48 mins";
    }
    
    // DATA FOR COMPANION
    else if (title != null && title.contains("Companion")) {
        director = "Drew Hancock";
        cast = "Sophie Thatcher; Jack Quaid; Lukas Gage; Megan Suri; Harvey Guillén; Rupert Friend";
        synopsis = "A weekend getaway at a remote cabin turns to chaos when it's revealed that one of the guests -- a subservient android built for human companionship -- has gone haywire.";
        runtime = "1 hr 37 mins";
    }
    
    // DATA FOR UNTIL DAWN
    else if (title != null && title.contains("Until Dawn")) {
        director = "David F. Sandberg";
        cast = "Ella Rubin; Michael Cimino; Odessa A'zion; Ji-young Yoo; Belmont Cameli; Maia Mitchell; Peter Stormare";
        synopsis = "One year after her sister disappeared, Clover and her friends head to the remote valley where she vanished to search for answers. Exploring an abandoned visitor center, they soon encounter a masked killer who murders them one by one. However, when they mysteriously wake up at the beginning of the same night, they're forced to relive the terror over and over again.";
        runtime = "1 hr 43 mins";
    }
    
    // DATA FOR FINAL DESTINATION: BLOODLINES
    else if (title != null && title.contains("Final Destination")) {
        director = "Zach Lipovsky, Adam Stein";
        cast = "Kaitlyn Santa Juana; Teo Briones; Richard Harmon; Owen Patrick Joyner; Anna Lore; Brec Bassinger; Tony Todd";
        synopsis = "Plagued by a violent and recurring nightmare, a college student heads home to track down the one person who might be able to break the cycle of death and save her family from the grisly demise that inevitably awaits them all.";
        runtime = "1 hr 50 mins";
    }
    
    // DATA FOR MICKEY 17
    else if (title != null && title.contains("Mickey 17")) {
        director = "Bong Joon Ho";
        cast = "Robert Pattinson; Naomi Ackie; Steven Yeun; Toni Collette; Mark Ruffalo";
        synopsis = "A disposable employee is sent on a human expedition to colonize the ice world Niflheim. After one iteration dies, a new body is regenerated with most of his memories intact.";
        runtime = "2 hr 19 mins";
    }
    
    // DATA FOR THE CONJURING: LAST RITES
    else if (title != null && title.contains("The Conjuring")) {
        director = "Michael Chaves";
        cast = "Mia Tomlinson; Ben Hardy; Vera Farmiga; Patrick Wilson; Beau Gadsdon;";
        synopsis = "In 1986 paranormal investigators Ed and Lorraine Warren travel to Pennsylvania to vanquish a demon from a family's home.";
        runtime = "2 hr 15 mins";
    }
    
    // DATA FOR SINNERS
    else if (title != null && title.contains("Sinners")) {
        director = "Ryan Coogler";
        cast = "Hailee Steinfeld; Michael B. Jordan; Wunmi Mosaku; Omar Benson Miller; Jayme Lawson; Miles Caton; Li Jun Li; Delroy Lindo";
        synopsis = "Trying to leave their troubled lives behind, twin brothers return to their Mississippi hometown to start again, only to discover that an even greater evil is waiting to welcome them back.";
        runtime = "2 hr 17 mins";
    }
    
    // DATA FOR 28 YEARS LATERS
    else if (title != null && title.contains("28 Years Later")) {
        director = "Danny Boyle";
        cast = "Jodie Comer; Aaron Taylor-Johnson; Jack O'Connell; Alfie Williams; Ralph Fiennes";
        synopsis = "It's been almost three decades since the rage virus escaped from a biological weapons laboratory. Still living in a ruthlessly enforced quarantine, some have found ways to exist amid the infected. One such group of survivors lives on a small island connected to the mainland by a single, heavily defended causeway. When one of them decides to venture into the dark heart of the mainland, he soon discovers a mutation that has spread to not only the infected, but other survivors as well.";
        runtime = "1 hr 55 mins";
    }
    
    // DATA FOR DRAGON
    else if (title != null && title.contains("Dragon")) {
        director = "Dean DeBlois";
        cast = "Mason Thames, Nico Parker, Gerard Butler";
        synopsis = "On the rugged isle of Berk, a Viking boy named Hiccup defies centuries of tradition by befriending a dragon named Toothless. However, when an ancient threat emerges that endangers both species, Hiccup's friendship with Toothless becomes the key to forging a new future. Together, they must navigate the delicate path toward peace, soaring beyond the boundaries of their worlds and redefining what it means to be a hero and a leader.";
        runtime = "2 hr 5 mins";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%= title %> | Sinema Movies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body {
            background-color: #121212;
            color: #ffffff;
            font-family: 'Segoe UI', sans-serif;
            min-height: 100vh;
            padding-bottom: 50px;
        }

        /* Top Nav Area */
        .top-nav { padding: 30px 5%; display: flex; justify-content: space-between; align-items: center; }
        .back-link { color: #fff; text-decoration: none; font-size: 1.1rem; display: flex; align-items: center; gap: 8px; }
        .back-link:hover { color: #eb3349; }
        
        .btn-buy {
            background-color: #eb3349;
            color: white;
            border: none;
            padding: 10px 30px;
            border-radius: 25px; /* Pill shape */
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-decoration: none;
            transition: transform 0.2s;
        }
        .btn-buy:hover { background-color: #ff4b5c; color: white; transform: scale(1.05); }

        /* Movie Header Info */
        .movie-header { padding: 0 5%; margin-bottom: 40px; }
        .movie-title-large { font-size: 3.5rem; font-weight: 800; margin-bottom: 10px; line-height: 1.1; }
        .meta-line { color: #ccc; font-size: 1rem; display: flex; align-items: center; gap: 15px; margin-bottom: 30px; }
        .age-badge { background-color: #f1c40f; color: black; font-weight: bold; padding: 2px 8px; border-radius: 4px; font-size: 0.9rem; }

        /* Layout Columns */
        .poster-img-large {
            width: 100%;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        /* Details List */
        .detail-item { margin-bottom: 20px; }
        .detail-label { color: #ccc; font-weight: 600; font-size: 1rem; display: block; margin-bottom: 4px; }
        .detail-value { color: #fff; font-size: 1.1rem; line-height: 1.4; }

        /* Synopsis Area */
        .synopsis-section { margin-top: 40px; padding-top: 30px; border-top: 1px solid #333; }
        .section-heading { font-size: 1.5rem; font-weight: 700; margin-bottom: 15px; color: #fff; }
        .synopsis-text { color: #ddd; line-height: 1.6; font-size: 1.1rem; text-align: justify; }
    </style>
</head>
<body>

    <div class="top-nav">
        <a href="javascript:history.back()" class="back-link">
            <i class="fas fa-chevron-left"></i> Back
        </a>
    </div>

    <div class="container-fluid movie-header">
        
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="movie-title-large"><%= title %></h1>
                
                <div class="meta-line">
                    <span class="age-badge"><%= request.getParameter("rating") != null ? request.getParameter("rating") : "13" %></span>
                    <span><%= request.getParameter("genre") %></span>
                    <span>|</span>
                    <span><%= runtime %></span>
                    <span>|</span>
                    <span>English</span>
                </div>
            </div>
        </div>

        <div class="row">
            
            <div class="col-md-4 col-lg-3 mb-4">
                <img src="${pageContext.request.contextPath}/images/<%= img %>" class="poster-img-large" alt="Poster">
            </div>

            <div class="col-md-8 col-lg-9">
                
                <div class="row">
                    <div class="col-12 detail-item">
                        <span class="detail-label">Director:</span>
                        <div class="detail-value"><%= director %></div>
                    </div>

                    <div class="col-12 detail-item">
                        <span class="detail-label">Cast:</span>
                        <div class="detail-value"><%= cast %></div>
                    </div>

                    <div class="col-12 detail-item">
                        <span class="detail-label">Genre:</span>
                        <div class="detail-value"><%= request.getParameter("genre") %></div>
                    </div>

                    <div class="col-12 detail-item">
                        <span class="detail-label">Subtitles:</span>
                        <div class="detail-value">Bahasa Melayu, Chinese, English</div>
                    </div>
                </div>

                <div class="synopsis-section">
                    <h3 class="section-heading">Synopsis</h3>
                    <div class="synopsis-text">
                        <%= synopsis %>
                    </div>
                </div>
                
            </div>
        </div>

    </div>

</body>
</html>