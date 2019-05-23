global class Batch_LargeListDBOperation implements Database.Batchable<SObject>
{
    private List<SObject> items;
    private DAL_BaseObject.DatabaseOperation operation;

    global Batch_LargeListDBOperation(List<SObject> items, DAL_BaseObject.DatabaseOperation operation)
    {
        this.items = items;
        this.operation = operation;
    }

    global Iterable<SObject> start(Database.BatchableContext BC)
    {
        return items;
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope)
    {
        if (operation == DAL_BaseObject.DatabaseOperation.DBO_INSERT)
            DAL_BaseObject.insertDBObjects(scope);
        else if (operation == DAL_BaseObject.DatabaseOperation.DBO_UPDATE)
            DAL_BaseObject.updateDBObjects(scope);
        else if (operation == DAL_BaseObject.DatabaseOperation.DBO_DELETE)
            DAL_BaseObject.deleteDBObjects(scope);
    }

    global void finish(Database.BatchableContext BC) {}
}