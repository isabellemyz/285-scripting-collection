<head>
	<title>Loui question formatter</title>
	<style>
		body {
			font-family: Arial, sans-serif;
		}
	</style>
</head>

<body>
	<h1>Loui question formatter</h1>

	<p> This is a formatter for Professor Loui's Canvas questions for CSDS 285. He posts them on Canvas for recitation sections and for Thursday lecture. Each question is usually lowercase and separated by a line break. I capitalize each question, bold everything, and add a line break in between so that I can type my answer underneath faster.</p>

	<form method='POST'>
		<textarea name='textdata' rows='10' cols='100' autocomplete='off'></textarea>
		<br>
		<input type='submit' />
	</form>

	<?php

	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$questions = $_POST["textdata"];
		
		$lines = explode("\n", $questions);

		foreach ($lines as $line) {
			$line = ucfirst($line);
			$line = "<strong>$line</strong>";
			$line .= "<br><br>";

			echo $line;

		}

	}	

	?>
</body>
