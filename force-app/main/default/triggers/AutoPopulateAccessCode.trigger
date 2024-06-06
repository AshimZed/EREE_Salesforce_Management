trigger AutoPopulateAccessCode on Contact (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        AutoPopAccCodeTriggerHandler.generateAccessCodeField(Trigger.new);
    }

}