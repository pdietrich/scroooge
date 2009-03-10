Core_Functions = {

	addParticipant: function() {

		var strHtml      = '<div class="containerTop"></div>' +
		                   '<div class="containerContent">' +
		                   ' ' +
		                   '	<table cellspacing="0" width="100%">' +
		                   '		<tr>' +
		                   '			<td class="label"><label for="debtor[]">Participant (Email address / Name)</label></td>' +
						   '			<td class="input">' +
						   '				<select name="debtor[]">' +
						   '					<option value="thorsten&#46;sven&#46;schmidt&#64;googlemail&#46;com">thorsten&#46;sven&#46;schmidt&#64;googlemail&#46;com</option>' +
						   '					<option value="mail&#64;jens&#46;scherbl&#46;net">mail&#64;jens&#46;scherbl&#46;net</option>' +									
						   '				</select>' +
						   '			</td>' +
		                   '		</tr>' +
		                   '		<tr>' +
		                   '			<td class="label"><label for="paysfor[]">Pays for ... people</label></td>' +
		                   '			<td class="input"><input type="text" name="paysfor[]" maxlength="10" /></td>' +
		                   '		</tr>' +
		                   '	</table>' +
						   ' ' +
		                   '</div>' +
		                   '<div class="containerBottom"></div>';
						   
		var objContainer = new Element('div', { 'class': 'container' }).update(strHtml);

		$('addParticipant').insert({ before: objContainer });
		
		new Effect.ScrollTo(objContainer);
	}
};