const Auth = artifacts.require("AuthWallet");

require("chai").use(require("chai-as-promised")).should();

contract("AuthWallet", ([manager, user1, user2, user3]) => {
  let auth;

  before(async () => {
    auth = await Auth.new();
    await auth.createWallet( { from: user1 });
    await auth.createWallet({ from: user3 });
  });

  describe("Interacting with the wallet", async () => {
    it("Update lookup table successfully", async () => {
      const result = await auth.isCreated(user1);
      assert.equal(result, true, "Added created owner to lut");
    });

    it("Add new wallet succefully", async () => {
      const result = await auth.wallet_list(user1);
      assert.equal(result.owner.toString(), user1, "Added new owner");

    });

    it("Reject duplicate creations", async () => {
      await auth.createWallet({ from: user1 }).should.be.rejected;
    });


    it("Set personal details successfully", async () => {
      await auth.setPersonalDetails("My Personal details", { from: user1 });
      let result = await auth.wallet_list(user1);
      assert.equal(
        result.personalDetails,
        "My Personal details",
        "Added personal details"
      );

      assert.equal(
        result.digitalIdCreated,
        true,
        "Created Digital Id"
      );
    });

    it("Approve bank successfully", async () => {
      const result = await auth.approveBank("190253K", { from: user1 });
      assert.equal(result.receipt.status, true, "Added approved bank");
      
    });

    it("Reject approving without digital id", async ()=>{
      await auth.approveBank("190253K", { from: user3 }).should.be.rejected
    })

    it("Reject bank successfully", async () => {
      const result = await auth.rejectBank("190111K", { from: user1 });
      assert.equal(result.receipt.status, true, "Added rejected bank");
    });

    it("Reject rejecting without digital id", async ()=>{
      await auth.rejectBank("190253K", { from: user3 }).should.be.rejected
    })

    it("Send credetials successfully", async () => {
      const result = await auth.sendCreadentials({ from: user1 });
      assert.equal(result, "My Personal details", "Sent credetials");
      
    });

    it("Reject Sending credetials without digital ID", async () => {
      await auth.sendCreadentials({ from: user3 }).should.be.rejected;
      
      
    });
  });
});
