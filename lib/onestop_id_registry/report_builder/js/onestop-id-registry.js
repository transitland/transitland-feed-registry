$(document).ready(function() {
  $('table#operator-table').dataTable({
    responsive: true
  });
  $('table#feed-table').dataTable({
    responsive: true
  });
  $('table#us-ntd-comparison-table').dataTable({
    "order": [ 2, 'desc' ],
    responsive: true
  });
  $('table#gtfs-data-exchange-comparison-table').dataTable({
    "order": [ 1, 'desc' ],
    responsive: true
  });
});
