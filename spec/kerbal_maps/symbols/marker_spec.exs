defmodule KerbalMaps.Symbols.Marker.Spec do
  @moduledoc false

  use ESpec

  require Logger

  alias KerbalMaps.Symbols
  alias KerbalMaps.Symbols.Marker

  example_group "clamp/2" do
    context "when value is a Decimal" do
      let :min_decimal, do: Decimal.from_float(1.0)
      let :max_decimal, do: Decimal.from_float(100.0)
      let :value_under_range_decimal, do: Decimal.from_float(0.0)
      let :value_in_range_decimal, do: Decimal.from_float(50.0)
      let :value_over_range_decimal, do: Decimal.from_float(101.0)

      let :min_float, do: 1.0
      let :max_float, do: 100.00
      let :value_under_range_float, do: 0.0
      let :value_in_range_float, do: 50.0
      let :value_over_range_float, do: 101.0

      context "and both min and max are Decimals" do
        it "and value is in range" do
          expect(Marker.clamp(value_in_range_decimal(), {min_decimal(), max_decimal()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.clamp(value_under_range_decimal(), {min_decimal(), max_decimal()}) |> Decimal.equal?(min_decimal())) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.clamp(value_over_range_decimal(), {min_decimal(), max_decimal()}) |> Decimal.equal?(max_decimal())) |> to(be_truthy())
        end
      end

      context "and min is a Decimal" do
        it "and value is in range" do
          expect(Marker.clamp(value_in_range_decimal(), {min_decimal(), max_float()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.clamp(value_under_range_decimal(), {min_decimal(), max_float()}) |> Decimal.equal?(min_decimal())) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.clamp(value_over_range_decimal(), {min_decimal(), max_float()}) |> Decimal.equal?(max_decimal())) |> to(be_truthy())
        end
      end

      context "and max is a Decimal" do
        it "and value is in range" do
          expect(Marker.clamp(value_in_range_decimal(), {min_float(), max_decimal()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.clamp(value_under_range_decimal(), {min_float(), max_decimal()}) |> Decimal.equal?(min_decimal())) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.clamp(value_over_range_decimal(), {min_float(), max_decimal()}) |> Decimal.equal?(max_decimal())) |> to(be_truthy())
        end
      end

      context "and neither min and max are Decimals" do
        it "and value is in range" do
          expect(Marker.clamp(value_in_range_decimal(), {min_float(), max_float()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.clamp(value_under_range_decimal(), {min_float(), max_float()}) |> Decimal.equal?(min_decimal())) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.clamp(value_over_range_decimal(), {min_float(), max_float()}) |> Decimal.equal?(max_decimal())) |> to(be_truthy())
        end
      end
    end

    context "when value is a float" do
      let :min_float, do: 1.0
      let :max_float, do: 100.00
      let :value_under_range_float, do: 0.0
      let :value_in_range_float, do: 50.0
      let :value_over_range_float, do: 101.0

      it "and value is in range" do
        expect(Marker.clamp(value_in_range_float(), {min_float(), max_float()})) |> to(eq(value_in_range_float()))
      end

      it "and value is under range" do
        expect(Marker.clamp(value_under_range_float(), {min_float(), max_float()})) |> to(eq(min_float()))
      end

      it "and value is over range" do
        expect(Marker.clamp(value_over_range_float(), {min_float(), max_float()})) |> to(eq(max_float()))
      end
    end

    context "when value is an integer" do
      let :min_integer, do: 1
      let :max_integer, do: 100
      let :value_under_range_integer, do: 0
      let :value_in_range_integer, do: 50
      let :value_over_range_integer, do: 101

      it "and value is in range" do
        expect(Marker.clamp(value_in_range_integer(), {min_integer(), max_integer()})) |> to(eq(value_in_range_integer()))
      end

      it "and value is under range" do
        expect(Marker.clamp(value_under_range_integer(), {min_integer(), max_integer()})) |> to(eq(min_integer()))
      end

      it "and value is over range" do
        expect(Marker.clamp(value_over_range_integer(), {min_integer(), max_integer()})) |> to(eq(max_integer()))
      end
    end
  end

  example_group "wrap/3" do
    let :changeset_under_range, do: Symbols.change_marker(%Marker{}) |> Ecto.Changeset.change(%{latitude: Decimal.from_float(-91.0)})
    let :changeset_in_range, do: Symbols.change_marker(%Marker{}) |> Ecto.Changeset.change(%{latitude: Decimal.from_float(0.0)})
    let :changeset_over_range, do: Symbols.change_marker(%Marker{}) |> Ecto.Changeset.change(%{latitude: Decimal.from_float(91.0)})

    it "when value is in range" do
      expect(
        changeset_in_range()
        |> Marker.wrap([:latitude], {-90.0, 90.0})
        |> Ecto.Changeset.get_change(:latitude)
        |> Decimal.equal?(Decimal.from_float(0.0))
      ) |> to(be_truthy())
    end

    it "when value is under range" do
      expect(
        changeset_under_range()
        |> Marker.wrap([:latitude], {-90.0, 90.0})
        |> Ecto.Changeset.get_change(:latitude)
        |> Decimal.equal?(Decimal.from_float(89.0))
      ) |> to(be_truthy())
    end

    it "when value is over range" do
      expect(
        changeset_over_range()
        |> Marker.wrap([:latitude], {-90.0, 90.0})
        |> Ecto.Changeset.get_change(:latitude)
        |> Decimal.equal?(Decimal.from_float(-89.0))
      ) |> to(be_truthy())
    end
  end

  example_group "wrap/2" do
    context "when value is a Decimal" do
      let :min_decimal, do: Decimal.from_float(1.0)
      let :max_decimal, do: Decimal.from_float(100.0)
      let :value_under_range_decimal, do: Decimal.from_float(0.0)
      let :value_in_range_decimal, do: Decimal.from_float(50.0)
      let :value_over_range_decimal, do: Decimal.from_float(101.0)

      let :min_float, do: 1.0
      let :max_float, do: 100.00
      let :value_under_range_float, do: 0.0
      let :value_in_range_float, do: 50.0
      let :value_over_range_float, do: 101.0

      context "and both min and max are Decimals" do
        it "and value is in range" do
          expect(Marker.wrap(value_in_range_decimal(), {min_decimal(), max_decimal()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.wrap(value_under_range_decimal(), {min_decimal(), max_decimal()}) |> Decimal.equal?(Decimal.from_float(99.0))) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.wrap(value_over_range_decimal(), {min_decimal(), max_decimal()}) |> Decimal.equal?(Decimal.from_float(2.0))) |> to(be_truthy())
        end
      end

      context "and min is a Decimal" do
        it "and value is in range" do
          expect(Marker.wrap(value_in_range_decimal(), {min_decimal(), max_float()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.wrap(value_under_range_decimal(), {min_decimal(), max_float()}) |> Decimal.equal?(Decimal.from_float(99.0))) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.wrap(value_over_range_decimal(), {min_decimal(), max_float()}) |> Decimal.equal?(Decimal.from_float(2.0))) |> to(be_truthy())
        end
      end

      context "and max is a Decimal" do
        it "and value is in range" do
          expect(Marker.wrap(value_in_range_decimal(), {min_float(), max_decimal()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.wrap(value_under_range_decimal(), {min_float(), max_decimal()}) |> Decimal.equal?(Decimal.from_float(99.0))) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.wrap(value_over_range_decimal(), {min_float(), max_decimal()}) |> Decimal.equal?(Decimal.from_float(2.0))) |> to(be_truthy())
        end
      end

      context "and neither min and max are Decimals" do
        it "and value is in range" do
          expect(Marker.wrap(value_in_range_decimal(), {min_float(), max_float()}) |> Decimal.equal?(value_in_range_decimal())) |> to(be_truthy())
        end

        it "and value is under range" do
          expect(Marker.wrap(value_under_range_decimal(), {min_float(), max_float()}) |> Decimal.equal?(Decimal.from_float(99.0))) |> to(be_truthy())
        end

        it "and value is over range" do
          expect(Marker.wrap(value_over_range_decimal(), {min_float(), max_float()}) |> Decimal.equal?(Decimal.from_float(2.0))) |> to(be_truthy())
        end
      end
    end

    context "when value is a float" do
      let :min_float, do: 1.0
      let :max_float, do: 100.00
      let :value_under_range_float, do: 0.0
      let :value_in_range_float, do: 50.0
      let :value_over_range_float, do: 101.0

      it "and value is in range" do
        expect(Marker.wrap(value_in_range_float(), {min_float(), max_float()})) |> to(eq(value_in_range_float()))
      end

      it "and value is under range" do
        expect(Marker.wrap(value_under_range_float(), {min_float(), max_float()})) |> to(eq(99.0))
      end

      it "and value is over range" do
        expect(Marker.wrap(value_over_range_float(), {min_float(), max_float()})) |> to(eq(2.0))
      end
    end

    context "when value is an integer" do
      let :min_integer, do: 1
      let :max_integer, do: 100
      let :value_under_range_integer, do: 0
      let :value_in_range_integer, do: 50
      let :value_over_range_integer, do: 101

      it "and value is in range" do
        expect(Marker.wrap(value_in_range_integer(), {min_integer(), max_integer()})) |> to(eq(value_in_range_integer()))
      end

      it "and value is under range" do
        expect(Marker.wrap(value_under_range_integer(), {min_integer(), max_integer()})) |> to(eq(99))
      end

      it "and value is over range" do
        expect(Marker.wrap(value_over_range_integer(), {min_integer(), max_integer()})) |> to(eq(2))
      end
    end
  end
end
