/**
 * Copy an existing file.
 *
 * @param {String} originFileId ID of the origin file to copy.
 * @param {String} copyTitle Title of the copy.
 */
function copyFile(originFileId, copyTitle) {
    var body = {'title': copyTitle};
    var request = gapi.client.drive.files.copy({
      'fileId': originFileId,
      'resource': body
    });
    request.execute(function(resp) {
      console.log('Copy ID: ' + resp.id);
    });
  }