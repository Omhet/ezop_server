<?php

//  �� �������� ������� ����� �� ���� �����, ����� ����� ������ ����������!
require_once './includes/bootstrap.inc';
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);

//echo "<br>Inside actions profile";

//echo "<br>".$_GET['act'];
//echo "<br>".$_GET['id'];

$action = $_GET['act'];
$id = $_GET['id'];

if ($action == "d")
{
	// �������� ��������� � ��
	db_query("DELETE FROM node where nid = %s", $id);
}

// ��������������� ������� �� �������� �������
// ���� ������! ����� ������ ���� �������������!!!
$location = "Location: http://localhost/drupal/?q=user/".$_GET['u'];

//echo "<br>".$location;
//echo "<br>".$_SERVER['REMOTE_HOST'];

header ($location); 

?>