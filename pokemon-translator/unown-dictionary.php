<head>
	<title>Pokemon Translator</title>
	<style>
		body {
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        p {
            margin: 1px 0;
        }

        #translation {
            flex-direction: row;
        }
	</style>
</head>

<body>
	<h1>Unown Dictionary</h1>

	<p>Unown is a kind of Pokemon that can take on different forms which resemble letters of the English alphabet. This page lets you translate whatever you want into the Unown "language"!</p>
    <p>Note that the only punctuations represented by Unown are '!' and '?'<p>

	<form method='POST'>
		<textarea name='textdata' rows='10' cols='100' autocomplete='off'></textarea>
		<br>
		<input type='submit' />
	</form>

	<?php
    $characters = array_merge(range('a', 'z'), ['!', '?']); // making full range of characters
    
    // array_combine($keys, $values)
    $unown_mapping = array_combine($characters, array_map(function ($char) {
        return "unown-$char.png";
    }, $characters));

	if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $text = $_POST["textdata"]; // get entered data
        $text = strtolower($text); // lower case everything

        // lots of processing happening!!
		for ($i = 0; $i < strlen($text); $i++) {
            $char = $text[$i];
            if (isset($unown_mapping[$char])) {
                echo "<img src='images/" . $unown_mapping[$char] . "' alt='$char' width='50' height='50'>";
            } elseif ($char == ' ') {
                echo "<span style='width: 40px; display: inline-block;'>&nbsp;</span>"; // making spaces bigger
            } else {
                echo $char;
            }
        }
	}	

	?>
</body>