$(function(){
	const solutionForm = $('form.solution_form');
	const solutionField = $('textarea.solution_field');
	solutionForm.on('ajax:success', fillSolution);
	solutionForm.on('ajax:error', showSolutionError);

	function fillSolution(successEvent) {
		const [responseData, _status, _xhr] = successEvent.detail;
		solutionField.val(JSON.stringify(responseData));
	}

	function showSolutionError(errorEvent) {
		const [_responseData, status, _xhr] = errorEvent.detail;
		solutionField.val(status);
	}
});