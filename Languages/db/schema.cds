 namespace sample.db;
entity Order {
    key ID:UUID;
    name: localized String @title:'{i18n>name}';
    
}