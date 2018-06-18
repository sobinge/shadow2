=================================================================
    # Title: Wordpress SB Uploader Plugin Shell Upload Vulnerability
    # Author: JingoBD
    # Category: webapps
    # Team: Bangladesh Cyber Army
    # Greetz: Bedu33n,N!1L,Rex0Man & All Member of BCA.
    # http://facebook.com/life.is.code
    # Plugin URI: http://wordpress.org/extend/plugins/sb-uploader/
    # Plugin Description: Allows the simple uploading of images to posts,
    pages, categories and custom post types/taxonomies. Provides
    shortcodes and PHP functions for easy addition to your site.
    # Version: 3.2 (Last Version)
    # Risk : High
    Tested on: Linux (Ubuntu)
    --------------------------------
    -[Exploit]-:
    1. Dork: inurl:plugins/sb-uploader
    2. Register vulnerable site. www.site.com/wp-register.php [N.B: If
    public registration disable This exploit is not work]
    3. Confrim your email, then login.
    4. Add a new post. title,body something if you want. Look right
    slidbar "SB Uploader" panel and upload a shell[PHP Shell]. Then
    publish this post.
    5. Now You get a new url. like: ""
    Existing Post Image URL: /wp/wp-content/uploads/2012/02/img1.php
    That is your shell Link. ""
    ---------------------------------
    Thanks to ALLAH, who give me knowledge.
    Long Live Bangladesh
    My team Facebook Group: http://facebook.com/groups/bdcyberarmy