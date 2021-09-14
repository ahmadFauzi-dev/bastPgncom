<p>An embedded view appears below:</p>

<?php

// This user-provided library should define get_user(), which returns the 
// name of the user currently logged into this application.
//
include 'auth.php';

// Tableau-provided functions for doing trusted authentication
include 'tableau_trusted.php';

?>

<iframe src="<?php echo get_trusted_url(get_user(),'localhost','views/Date-Time/DateCalcs')?>"
        width="400" height="400">
</iframe>

<p>
This was created using trusted authentication.
</p>