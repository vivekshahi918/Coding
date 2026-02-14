async applyRetentionPolicy(days: number = 30){
  const thresholdDate = new Date();
  thresholdDate.setDate(thresholdDate.getDate() - days);

  const result = await this.emailModel.updateMany(
    {
        receiveDate: { $lt: thresholdDate },
        isDeleted: { $ne: true}
    },
    {
        $set: {
            isDeleted: true,
            deletedAt: new Date()
        }
    }
  );
    console.log(`Retention policy applied. ${result.nModified} emails marked as deleted.`);
}