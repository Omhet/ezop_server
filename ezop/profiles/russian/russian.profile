<?php
// $Id: russian.profile,v 1.2 2007/03/14 20:27:58 vadbarsdrupalorg Exp $

/**
 * Russian Drupal installation profile
 *
 * Thanks to goba, the author of autolocale module
 */

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 *  An array of modules to be enabled.
 */
function russian_profile_modules() {
// Core modules / ���㫨 ��
  $core = array('block', 'color', 'comment', 'filter', 'help', 'menu', 'node', 'system', 'taxonomy', 'user', 'watchdog', 'locale');

// Contrib modules / �������⥫�� ���㫨 (����� ��������� ��� 㤠���� �� ����室�����)
  $contrib = array('autolocale');

  return array_merge($core, $contrib);
}

/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 *   An array with keys 'name' and 'description' describing this profile.
 *   description: �롥�� ��� ��䨫� ��� ��⠭���� ���᪮�� Drupal.
 */
function russian_profile_details() {
  return array(
    'name' => 'Russian Drupal',
    'description' => 'Выберите этот профиль для установки Русского Drupal.'
  );
}

/**
 * Uses functionality in autolocale.install to import PO files
 */
function russian_install() {
  _autolocale_install_po_files();
}

/**
 * Perform any final installation tasks for this profile.
 *
 * @return
 *   An optional HTML string to display to the user on the final installation
 *   screen.
 */
function russian_profile_final() {
  // �᫨ �ࢥ� ࠡ�⠥� �� � 'safe mode', 㢥��稢��� ���ᨬ��쭮� �६� �믮������ �ਯ⮢:
  if (!ini_get('safe_mode')) {
    set_time_limit(0);
  }

  // ��ॢ���� ��������� Primary links
  db_query("UPDATE {menu} SET title = '".st('Primary links')."' WHERE mid = '2'");

  // Insert default user-defined node types into the database.
  $common = array(
    'module' => 'node',
    'custom' => TRUE,
    'modified' => TRUE,
    'locked' => FALSE,
    'has_body' => TRUE,
    'body_label' => st('Body'),
    'has_title' => TRUE,
    'title_label' => st('Title'),
  );
  $types = array(
    array_merge(
      array(
        'type' => 'page',
        'name' => st('Page'),
        'description' => st('If you want to add a static page, like a contact page or an about page, use a page.')
      ), 
      $common
    ),
    array_merge(
      array(
        'type' => 'story',
        'name' => st('Story'),
        'description' => st('Stories are articles in their simplest form: they have a title, a teaser and a body, but can be extended by other modules. The teaser is part of the body too. Stories may be used as a personal blog or for news articles.')
      ),
      $common
    ),
  );

  foreach ($types as $type) {
    $type = (object) _node_type_set_defaults($type);
    node_type_save($type);
  }

  // Default page to not be promoted and have comments disabled.
  variable_set('node_options_page', array('status'));
  variable_set('comment_page', COMMENT_NODE_DISABLED);

  // Don't display date and author information for page nodes by default.
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_node_info_page'] = FALSE;
  variable_set('theme_settings', $theme_settings);

/** 
 * Configuration / �������⥫�� ����ன��
 */

  // Sitename / �������� ᠩ� (����஢�� UTF-8), ���ਬ��, "���᪨� Drupal"
  variable_set('site_name', 'Русский Drupal');


  // Turn on user pictures / ����稬 ������ ���짮��⥫��
//  variable_set('user_pictures', 1);


  // Register site admin / �������� �������� ������ ᠩ� � ����� ��� �� �ࠢ�
  // ���: admin, ��஫�: admin, �.����: admin@mydrupalsite.ru
  // ��������!!! �� ������ �������� �� ����ன�� �� ࠡ�祬 ᠩ� !!!
  db_query("INSERT INTO {users} (uid, name, pass, mail, created, status) VALUES(1, 'admin', '%s', 'admin@mydrupalsite.ru', %d, 1)", md5('admin'), time());
  user_authenticate('admin', 'admin');


  // Setup some standard roles (non-uid-1 admin, redactor (content admin) etc.),
  // and configure all perms appropriately.
  // ��������  ��᪮�쪮 �⠭������ ஫�� (����� ᠩ�, ।���� (�ࠢ����� ᮤ�ঠ����) � �.�.)
  // � ����� ᮮ⢥�����騥 �ࠢ� ����㯠.
        //�ਬ��� �������� ஫�� (eng/rus/rus UTF-8):
        //redactor ।���� редактор
        //administrator ����������� администратор
        //moderator ������� модератор
        //author ���� автор

//  db_query("INSERT INTO {role} (rid, name) VALUES (3, 'администратор')");
//  db_query("INSERT INTO {role} (rid, name) VALUES (4, 'редактор')");

  // Insert new role's permissions / ��।���� �ࠢ� ��� ஫��
//  db_query("INSERT INTO {permission} (rid, perm, tid) VALUES (3, 'administer blocks, use PHP for block visibility, access comments, administer comments, post comments, post comments without approval, access devel information, execute php code, devel_node_access module, view devel_node_access information, administer filters, administer menu, access content, administer content types, administer nodes, create page content, create story content, edit own page content, edit own story content, edit page content, edit story content, revert revisions, view revisions, access administration pages, administer site configuration, select different theme, administer taxonomy, access user profiles, administer access control, administer users, change own username', 0)");
//  db_query("INSERT INTO {permission} (rid, perm, tid) VALUES (4, 'administer blocks, access comments, administer comments, post comments, post comments without approval, administer menu, access content, administer nodes, create page content, create story content, edit own page content, edit own story content, edit page content, edit story content, revert revisions, view revisions, access user profiles, administer users', 0)");


  // Change front page / ������� ������� ��࠭��� 
  // ���ਬ�� �� "user/register", �⮡� �ࠧ� �������� �� ��࠭��� ॣ����樨 ��ࢮ�� ���짮��⥫�-������
  // ��� �� ���� ����� ��࠭���
  // (������ ���筮� "node" ����� ��⮬ �� ��࠭�� admin/settings/site-information)
// variable_set('site_frontpage', 'user/register');

  // Set date and timezone settings
  // ���������� ����ன�� ���� � �६���
  // ��६����:
  // Y	���浪��� ����� ����, 4 ����	�ਬ���: 1999, 2003
  // y	����� ����, 2 ����	�ਬ���: 99, 03
  // d  ���� �����, 2 ���� � ����騬� ��ﬨ	�� 01 �� 31
  // j	���� ����� ��� ������ �㫥�	�� 1 �� 31
  // F	������ ������������ �����, ���ਬ�� January ��� March	�� January �� December
  // M	����饭��� ������������ �����, 3 ᨬ����	�� Jan �� Dec
  // m	���浪��� ����� ����� � ����騬� ��ﬨ	�� 01 �� 12
  // n	���浪��� ����� ����� ��� ������ �㫥�	�� 1 �� 12
  // g	���� � 12-�ᮢ�� �ଠ� ��� ������ �㫥�	�� 1 �� 12
  // G	���� � 24-�ᮢ�� �ଠ� ��� ������ �㫥�	�� 0 �� 23
  // h	���� � 12-�ᮢ�� �ଠ� � ����騬� ��ﬨ	�� 01 �� 12
  // H	���� � 24-�ᮢ�� �ଠ� � ����騬� ��ﬨ	�� 00 �� 23
  // i	������ � ����騬� ��ﬨ	00 to 59
  // s	���㭤� � ����騬� ��ﬨ	�� 00 �� 59
  // D	����饭��� ������������ ��� ������, 3 ᨬ����	�� Mon �� Sun
  // l (���筠� 'L')	������ ������������ ��� ������	�� Sunday �� Saturday
  variable_set('date_format_short', 'd.m.y'); // 01.12.07
  variable_set('date_format_medium', 'd.m.Y в H:i'); // 01.12.2007 � 23:45
  variable_set('date_format_long', 'd F Y г., H:i - l'); // 01 ������� 2007 �., 23:45 - �।�
  // ���� ���� ������ - �������쭨�
  variable_set('date_first_day', '1');

}
