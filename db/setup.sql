LOCK TABLE `statuses` WRITE;
INSERT INTO `statuses` (`label`, `directly_assigned`, `role`) VALUES ('Distribution', '1', 'Distributor') , ('Translation', '1', 'Translator') , ('Scientific Review', '1', 'Scientific Reviewer') , ('Linguistic Review', '1', 'Linguistic Reviewer') , ('Final Editing', '1', 'Final Editor') , ('test', '0', 'tester');
UNLOCK TABLES;
