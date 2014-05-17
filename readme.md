javap.vim
=========

Description
-----------
javap�p��vim�v���O�C���ł��B
jar�Ɋ܂܂��N���X�̈ꗗ�\���ƁA���̈ꗗ����w�肵���N���X�̒�`�𒲂ׂ邱�Ƃ��\�ł��B

Requirements
------------
�K�v�Ȃ̂��͎̂��̂Ƃ���B

* jar
* javap

Setting
-------
# �ǂݍ���jar�̐ݒ�
���̂悤�ɕK�v��jar��.vimrc�ɒ�`����

    let g:javap_defines = [
      \ { 'jar' : $JAVA_HOME . '/jre/lib/rt.jar', 'javadoc' : 'http://docs.oracle.com/javase/jp/6/api/%s.html' },
      \ ]

# jar��javap�̃p�X�w��
jar��javap�Ƀp�X��ʂ�

Usage
-----
* �N��

���̃R�}���h�ŋN������ƃN���X�ꗗ���\�������

(����N����͒x���ł����A�L���b�V������̂Ŏ���ȍ~�͑����͂�)

    :Javap

* �N���X�ꗗ

�N���X���̏��Return�L�[�������ƃN���X��`���\������܂��B

* �N���X��`

�N���X���̏��Return�L�[�������ƃN���X��`���ǉ��\������܂��B
Backspace�ŃN���X�ꗗ�ɖ߂�܂��B
�N���X�ȊO�̏��Return�L�[�������Ɗ֐��̒�`�������N����܂��B

* �L���b�V���̃N���A

��x���[�h�����N���X�ꗗ��~/.vim_javap �ɃL���b�V�����܂��B
������N���A����ꍇ�́A���̃R�}���h�����s���Ă��������B

    :JavapClearCache

ScreenShots
-----------

* Javap �N���X�ꗗ


HISTORY
-------
*v1.0 2014.03.06 yuratomo

Initial version


