Add-Type -AssemblyName PresentationFramework # for text boxes without input: [System.Windows.MessageBox]::Show("...")

Function GUI_TextBox ($Box_title, $Input_Type, $Example){
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	$form = New-Object System.Windows.Forms.Form
	$form.Text = $Box_title ### Text to be displayed in the title
	$largeur_additionnelle = ($Input_Type.Length) * 4
	$largeur = 310 + $largeur_additionnelle
	$form.Size = New-Object System.Drawing.Size($largeur,175) ### Size of the window
	$form.StartPosition = 'CenterScreen'  ### Optional - specifies where the window should start
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow  ### Optional - prevents resize of the window
	$form.Topmost = $true  ### Optional - Opens on top of other windows
	
	# OK button
	$OKButton = New-Object System.Windows.Forms.Button
	$largeur = 70 + ($largeur_additionnelle)/2
	$OKButton.Location = New-Object System.Drawing.Point($largeur,105) ### Location of where the button will be
	$OKButton.Size = New-Object System.Drawing.Size(75,23) ### Size of the button
	$OKButton.Text = 'OK' ### Text inside the button
	$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$form.AcceptButton = $OKButton
	$form.Controls.Add($OKButton)
	
	# cancel button
	$CancelButton = New-Object System.Windows.Forms.Button
	$largeur = 155 + ($largeur_additionnelle)/2
	$CancelButton.Location = New-Object System.Drawing.Point($largeur,105) ### Location of where the button will be
	$CancelButton.Size = New-Object System.Drawing.Size(75,23) ### Size of the button
	$CancelButton.Text = 'Cancel' ### Text inside the button
	$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$form.CancelButton = $CancelButton
	$form.Controls.Add($CancelButton)
	
	# Input text
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,10) ### Location of where the label will be
	$label.AutoSize = $True
	$Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold) ### Formatting text for the label
	$label.Font = $Font
	$label.Text = $Input_Type ### Text of label, defined by the parameter that was used when the function is called
	$label.ForeColor = 'Green' ### Color of the label text
	$form.Controls.Add($label)
	
	$textBox = New-Object System.Windows.Forms.TextBox
	$textBox.Location = New-Object System.Drawing.Point(10,40) ### Location of the text box
	$largeur = 275 + $largeur_additionnelle
	$textBox.Size = New-Object System.Drawing.Size($largeur,500) ### Size of the text box
	$textBox.Multiline = $false ### Allows multiple lines of data
	$textbox.AcceptsReturn = $true ### By hitting enter it creates a new line
	$textBox.ScrollBars = "Vertical" ### Allows for a vertical scroll bar if the list of text is too big for the window
	$form.Controls.Add($textBox)
	
	# Example text
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,75) ### Location of where the label will be
	$label.AutoSize = $True
	$Font = New-Object System.Drawing.Font("Arial",10) ### Formatting text for the label
	$label.Font = $Font
	$label.Text = "Exemple: $Example" ### Text of label, defined by the parameter that was used when the function is called
	$label.ForeColor = 'Black' ### Color of the label text
	$form.Controls.Add($label)
	
	$form.Add_Shown({$textBox.Select()}) ### Activates the form and sets the focus on it
	$result = $form.ShowDialog() ### Displays the form 
	
	### If the OK button is selected do the following
	if ($result -eq [System.Windows.Forms.DialogResult]::OK)
	{
		return $textBox.Lines
	}
	
	### If the cancel button is selected do the following
	if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
	{
		Exit
	}
}

Function throw_error ($message){
    [System.Windows.MessageBox]::Show("Erreur: $message")
	Exit
}

###############################################################
# Dossier contenant les fichiers
###############################################################

$dir = GUI_TextBox "" "Chemin complet du dossier contenant les fichiers à renommer:" "C:\Users\gandalf\Desktop\dossier"

# test if input is empty
if (!$dir) {
    throw_error("Le dossier """" est introuvable.")
}

# test if dir exists
if (-Not (Test-Path -Path $dir)) {
    throw_error("Le dossier ""$dir"" est introuvable.")
}

###############################################################
# Préfixe à ajouter aux noms des fichiers
###############################################################

$prefix = GUI_TextBox "" "Préfixe à ajouter aux noms des fichiers:" "29-08-154_FL_STEMS_"

# test if input is empty
if (!$prefix) {
    throw_error("Le préfix ne peut être vide.")
}

###############################################################
# Renaming
###############################################################

Get-ChildItem $dir | 
Foreach-Object {
	if (Test-Path -Path $_.FullName -PathType Leaf) { # avoiding subdirectories
	    # renaming the file
        Rename-Item -Path $_.FullName -NewName "$prefix$_.Name"
    }
}

[System.Windows.MessageBox]::Show("Done.")
