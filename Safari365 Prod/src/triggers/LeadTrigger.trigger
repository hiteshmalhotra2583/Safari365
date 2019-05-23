trigger LeadTrigger on Lead (before insert,before update, after insert, after update)
{
		TH_Lead l = new TH_Lead();
		l.run();
}