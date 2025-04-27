import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Input, Section, Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  availability: number;
  last_caller: string | null;
  available_transmitters: string[];
  transmitters: {
    phone_category: string;
    phone_color: string;
    phone_id: string;
    phone_icon: string;
    phone_ref: string;
    blocked: boolean;
  }[];
};

type Props = Partial<{
  block_menu: boolean;
}>;

export const PhoneMenu = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={500} height={400}>
      <Window.Content>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { availability, last_caller } = data;
  const available_transmitters = Object.keys(data.available_transmitters);
  const transmitters = data.transmitters.filter((val1) =>
    available_transmitters.includes(val1.phone_id),
  );

  const categories: string[] = [];
  for (let i = 0; i < transmitters.length; i++) {
    let data = transmitters[i];
    if (categories.includes(data.phone_category)) continue;

    categories.push(data.phone_category);
  }

  const [currentSearch, setSearch] = useState('');
  const [selectedPhone, setSelectedPhone] = useState('');
  const [currentCategory, setCategory] = useState(categories[0]);
  const [block_menu, toggleBlockMenu] = useState(props.block_menu);

  let dnd_tooltip = 'Do Not Disturb is DISABLED';
  let dnd_locked = 'No';
  let dnd_icon = 'volume-high';
  if (availability === 1) {
    dnd_tooltip = 'Do Not Disturb is ENABLED';
    dnd_icon = 'volume-xmark';
  } else if (availability >= 2) {
    dnd_tooltip = 'Do Not Disturb is ENABLED (LOCKED)';
    dnd_locked = 'Yes';
    dnd_icon = 'volume-xmark';
  } else if (availability < 0) {
    dnd_tooltip = 'Do Not Disturb is DISABLED (LOCKED)';
    dnd_locked = 'Yes';
  }

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs>
            {categories.map((val) => (
              <Tabs.Tab
                selected={val === currentCategory}
                onClick={() => setCategory(val)}
                key={val}
              >
                {val}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Input
            fluid
            value={currentSearch}
            placeholder="Search for a phone"
            onInput={(e, value) => setSearch(value.toLowerCase())}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            <Tabs vertical>
              {transmitters.map((val) => {
                if (
                  val.phone_category !== currentCategory ||
                  !val.phone_id.toLowerCase().match(currentSearch)
                ) {
                  return;
                }
                return (
                  <Tabs.Tab
                    selected={selectedPhone === val.phone_id}
                    onClick={() => {
                      if (!block_menu) {
                        if (selectedPhone === val.phone_id) {
                          act('call_phone', { phone_id: selectedPhone });
                        } else {
                          setSelectedPhone(val.phone_id);
                        }
                      }
                    }}
                    key={val.phone_id}
                    color={val.phone_color}
                    onFocus={() =>
                      document.activeElement
                        ? (document.activeElement as HTMLElement).blur()
                        : false
                    }
                    icon={val.phone_icon}
                  >
                    <Stack>
                      <Stack.Item grow>{val.phone_id}</Stack.Item>
                      {block_menu ? (
                        <Stack.Item mr="15px">
                          <Button
                            compact
                            pr="4px"
                            pl="4px"
                            color={val.blocked ? 'red' : 'grey'}
                            opacity={0.5}
                            onClick={() => {
                              act('toggle_caller_block', {
                                target_ref: val.phone_ref,
                              });
                            }}
                          >
                            {val.blocked ? 'Unblock' : 'Block'} Caller
                          </Button>
                        </Stack.Item>
                      ) : null}
                    </Stack>
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Section>
        </Stack.Item>
        {!!selectedPhone && (
          <Stack.Item>
            <Button
              color="good"
              fluid
              textAlign="center"
              onClick={() => act('call_phone', { phone_id: selectedPhone })}
            >
              Dial
            </Button>
          </Stack.Item>
        )}
        {!!last_caller && <Stack.Item>Last Caller: {last_caller}</Stack.Item>}
        <Stack.Item>
          <Button
            color="red"
            icon="user"
            fluid
            textAlign="center"
            onClick={() => toggleBlockMenu(!block_menu)}
          >
            {block_menu ? 'Close Block Menu' : 'Manage Blocked Callers'}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            color="red"
            tooltip={dnd_tooltip}
            disabled={dnd_locked === 'Yes'}
            icon={dnd_icon}
            fluid
            textAlign="center"
            onClick={() => act('toggle_dnd')}
          >
            Do Not Disturb
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
